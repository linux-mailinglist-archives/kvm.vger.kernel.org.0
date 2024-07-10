Return-Path: <kvm+bounces-21297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA5492CEBB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 12:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0F11289FE3
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37E218FA28;
	Wed, 10 Jul 2024 10:01:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01CB1B86F3
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 10:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720605664; cv=none; b=Cfxd2rYS04vlN0iyy+/HIvH6OM15FVZVVUpw6NEi2KIT7n4662UB9z9ZKCZfIFF2ZGgDkq68kZimKvb7JtTJAqL2A/3tB5yY7OLLQrGj5jgeZyVAe1h+6KOEO7zmyau8O8By5OjY5j5/tugkfhuubQveImDmjADKbweVh6R0/C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720605664; c=relaxed/simple;
	bh=APoOJOJ2oyjsRyq3lH6pZZDCwoPQYqT0JipDFCq3R60=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=oCO49oO1UO0ZfpK0weN6kIfg0+OlmC8IlppGDrZum+8PUMGMpPPkvldjY36A2JUGjprxQkTlsO74VqO4I5mAf4JYMLXyVRZmHs2Ccfm2GMCcukoQiFeaMIwLVBrk7x0VY3KWUP8/CBYtkITML7sA1/95u0rX2go2k6874EhuAcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4c85f7543ea311ef93f4611109254879-20240710
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:51acd196-0955-4347-b31b-5662ccf00fb3,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:5,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:82c5f88,CLOUDID:8bbf56a3b68735eccf1d8bcedbbd1c8a,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,URL:0
	,File:2,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
	,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 4c85f7543ea311ef93f4611109254879-20240710
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <leixiang@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1641265678; Wed, 10 Jul 2024 18:00:55 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 0AF81E000746;
	Wed, 10 Jul 2024 18:00:55 +0800 (CST)
X-ns-mid: postfix-668E5BD6-8600512066
Received: from [10.42.12.63] (unknown [10.42.12.63])
	by mail.kylinos.cn (NSMail) with ESMTPA id 6EF32E000746;
	Wed, 10 Jul 2024 18:00:54 +0800 (CST)
Content-Type: multipart/mixed; boundary="------------GEMYFdG8Md2ADYZW4eYs23Lh"
Message-ID: <bc4212f7-95d8-428a-95fc-f6c8e017cbe5@kylinos.cn>
Date: Wed, 10 Jul 2024 18:00:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm tools:Fix memory leakage in open all disks
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
 xieming@kylinos.cn
References: <20240618075247.1394144-1-leixiang@kylinos.cn>
 <1720577870543075.69.seg@mailgw.kylinos.cn>
 <c651de19-4346-4be9-afe5-16427015680f@kylinos.cn> <Zo5GDbKDYmY4uPYz@arm.com>
Content-Language: en-US
From: leixiang <leixiang@kylinos.cn>
In-Reply-To: <Zo5GDbKDYmY4uPYz@arm.com>

This is a multi-part message in MIME format.
--------------GEMYFdG8Md2ADYZW4eYs23Lh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Dear Alex,
Thanks for your reply.

On 2024/7/10 16:27, Alexandru Elisei wrote:
> Hi,
> 
> On Wed, Jul 10, 2024 at 04:12:37PM +0800, leixiang wrote:
>> Dear Alex,
>> Thank you for your reply and suggestions.
>>
>> On 2024/7/9 18:12, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> Adding the kvmtool maintainers (you can find them in the README file).
>>>
>>> On Tue, Jun 18, 2024 at 03:52:47PM +0800, leixiang wrote:
>>>> Fix memory leakage in disk/core disk_image__open_all when malloc disk failed,
>>>> should free the disks that already malloced.
>>>>
>>>> Signed-off-by: Lei Xiang <leixiang@kylinos.cn>
>>>> Suggested-by: Xie Ming <xieming@kylinos.cn>
>>>> ---
>>>>  disk/core.c | 6 ++++--
>>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/disk/core.c b/disk/core.c
>>>> index dd2f258..affeece 100644
>>>> --- a/disk/core.c
>>>> +++ b/disk/core.c
>>>> @@ -195,8 +195,10 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
>>>>  
>>>>  		if (wwpn) {
>>>>  			disks[i] = malloc(sizeof(struct disk_image));
>>>> -			if (!disks[i])
>>>> -				return ERR_PTR(-ENOMEM);
>>>> +			if (!disks[i]) {
>>>> +				err = ERR_PTR(-ENOMEM);
>>>> +				goto error;
>>>> +			}
>>>>  			disks[i]->wwpn = wwpn;
>>>>  			disks[i]->tpgt = tpgt;
>>>
>>> Currently, the latest patch on branch master is ca31abf5d9c3 ("arm64: Allow
>>> the user to select the max SVE vector length"), and struct disk_image
>>> doesn't have a tpgt field. Did you write this patch on a local branch?
>>>
>>>>  			continue;
>>>
>> There is no doubt that you are correct, I had realize that I git clone a wrong repo.
>>> This is what the 'error' label does:
>>>
>>> error:
>>>         for (i = 0; i < count; i++)
>>>                 if (!IS_ERR_OR_NULL(disks[i]))
>>>                         disk_image__close(disks[i]);
>>>
>>>         free(disks);
>>>         return err;
>>>
>>> And disk_image__close() ends up poking all sort of fields from struct
>>> disk_image, including dereferencing pointers embedded in the struct. If
>>> WWPN is specified for a disk, struct disk_image is allocated using malloc
>>> as above, the field wwwpn is set and the rest of the fields are left
>>> uninitialized. Because of this, calling disk_image__close() on a struct
>>> disk_image with wwpn can lead to all sorts of nasty things happening.
>>>
>>> May I suggest allocating disks[i] using calloc in the wwpn case to fix
>>> this? Ideally, you would have two patches:
>>>
>>> 1. A patch that changes the disk[i] allocation to calloc(), to prevent
>>> disk_image__close() accessing unitialized fields when disk_image__open()
>>> fails after initialized a WWPN disk.
>>>
>>> 2. This patch.
>>>
> 
>> When the new disk_image is allocated successfully, 
>> the fields will eventually be initialized by disk_image__new().
>> And disk_image__close() accessing fields also checked before use.
>> So I don't think it's necessary to replace malloc with calloc.
> 
> When and where is disk_image__new() called?
>
Sorry, I was ignored the 'continue' in the code flow.
There is no doubt that your suggestions are forward-looking, 
and I have made changes to the patch according to your suggestions. 
 
> Thanks,
> Alex

Thank you very much!
--------------GEMYFdG8Md2ADYZW4eYs23Lh
Content-Type: text/x-patch; charset=UTF-8;
 name="v3-0001-kvmtool-disk-core-Fix-memory-leakage-in-open-all-.patch"
Content-Disposition: attachment;
 filename*0="v3-0001-kvmtool-disk-core-Fix-memory-leakage-in-open-all-.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA1NmI2MGNmNzBhMGM1ZjdjZGFmZTY4MDRkYWJiZTcxMTJjMTBmN2ExIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBsZWl4aWFuZyA8bGVpeGlhbmdAa3lsaW5vcy5jbj4K
RGF0ZTogV2VkLCAxMCBKdWwgMjAyNCAxNzo0NTo1MSArMDgwMApTdWJqZWN0OiBbUEFUQ0gg
djNdIGt2bXRvb2w6ZGlzay9jb3JlOkZpeCBtZW1vcnkgbGVha2FnZSBpbiBvcGVuIGFsbCBk
aXNrcwoKRml4IG1lbW9yeSBsZWFrYWdlIGluIGRpc2svY29yZSBkaXNrX2ltYWdlX19vcGVu
X2FsbCB3aGVuIG1hbGxvYyBkaXNrIGZhaWxlZCwKc2hvdWxkIGZyZWUgdGhlIGRpc2tzIHRo
YXQgYWxyZWFkeSBtYWxsb2NlZC4KQW5kIHRvIGF2b2lkIGZpZWxkcyBub3QgYmVpbmcgaW5p
dGlhbGl6ZWQgaW4gc3RydWN0IGRpc2tfaW1hZ2UsCnJlcGxhY2UgbWFsbG9jIHdpdGggY2Fs
bG9jLgoKU2lnbmVkLW9mZi1ieTogTGVpIFhpYW5nIDxsZWl4aWFuZ0BreWxpbm9zLmNuPgpT
dWdnZXN0ZWQtYnk6IFhpZSBNaW5nIDx4aWVtaW5nQGt5bGlub3MuY24+Ci0tLQogZGlzay9j
b3JlLmMgfCA4ICsrKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Rpc2svY29yZS5jIGIvZGlzay9jb3JlLmMK
aW5kZXggYjAwYjBjMC4uYTA4NGNkNCAxMDA2NDQKLS0tIGEvZGlzay9jb3JlLmMKKysrIGIv
ZGlzay9jb3JlLmMKQEAgLTE3MCw5ICsxNzAsMTEgQEAgc3RhdGljIHN0cnVjdCBkaXNrX2lt
YWdlICoqZGlza19pbWFnZV9fb3Blbl9hbGwoc3RydWN0IGt2bSAqa3ZtKQogCQl3d3BuID0g
cGFyYW1zW2ldLnd3cG47CiAKIAkJaWYgKHd3cG4pIHsKLQkJCWRpc2tzW2ldID0gbWFsbG9j
KHNpemVvZihzdHJ1Y3QgZGlza19pbWFnZSkpOwotCQkJaWYgKCFkaXNrc1tpXSkKLQkJCQly
ZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsKKwkJCWRpc2tzW2ldID0gY2FsbG9jKDEsIHNpemVv
ZihzdHJ1Y3QgZGlza19pbWFnZSkpOworCQkJaWYgKCFkaXNrc1tpXSkgeworCQkJCWVyciA9
IEVSUl9QVFIoLUVOT01FTSk7CisJCQkJZ290byBlcnJvcjsKKwkJCX0KIAkJCWRpc2tzW2ld
LT53d3BuID0gd3dwbjsKIAkJCWNvbnRpbnVlOwogCQl9Ci0tIAoyLjM0LjEKCg==

--------------GEMYFdG8Md2ADYZW4eYs23Lh--

