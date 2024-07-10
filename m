Return-Path: <kvm+bounces-21277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B82A92CCBB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:18:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADA5F28168E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66BB084D29;
	Wed, 10 Jul 2024 08:18:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA0A12BE9E
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720599494; cv=none; b=PONXIBSCfVKDAak9UrWbhSTRsyyW6PM5NxFlDHDy8W29sF1Pnf35Yk/Px0lPd20aIskP4abakRjAy/Xl8N9GItE7zqEdG9NzirYT1cABLIepXkqHteA5VcGDy8sIyvUZgwzPVin95Nu0UeIHDbVEF/d77S22vMSbDAANWhWBco8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720599494; c=relaxed/simple;
	bh=Ec4WiU1UO+RT26HsLmDfWDZ/reaqEvopPuK0aiOoXFM=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=U+aW8XFrsgVu2h95+G1JxNmYnbejBwHkLg4b5io8Z0JxoMO8153uIGJNQpA7xch4Z3GIz3nQ9aU1AOYMZCPJ4Gs3LgRBw00URQseiN5bLRXeVyWN2+nsxpg5SAdCplXmtXO9RfWt/1CRF1X/l8mc+8Cf2YcavfP0WNtcZ+CET08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2bf806763e9411ef93f4611109254879-20240710
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:0d6461e6-4dd8-40d6-91dc-2a02396b75e7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:5,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:82c5f88,CLOUDID:5366561f5bb114cd2e6ac68a61595700,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,URL:0
	,File:2,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
	,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 2bf806763e9411ef93f4611109254879-20240710
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <leixiang@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 402607814; Wed, 10 Jul 2024 16:12:38 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 62079E000747;
	Wed, 10 Jul 2024 16:12:38 +0800 (CST)
X-ns-mid: postfix-668E4276-3221551627
Received: from [10.42.12.63] (unknown [10.42.12.63])
	by mail.kylinos.cn (NSMail) with ESMTPA id DF257E000747;
	Wed, 10 Jul 2024 16:12:37 +0800 (CST)
Content-Type: multipart/mixed; boundary="------------jkXOCQSioAPa8KmW3dL6up9P"
Message-ID: <c651de19-4346-4be9-afe5-16427015680f@kylinos.cn>
Date: Wed, 10 Jul 2024 16:12:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm tools:Fix memory leakage in open all disks
To: Alexandru Elisei <alexandru.elisei@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: kvm@vger.kernel.org, xieming@kylinos.cn
References: <20240618075247.1394144-1-leixiang@kylinos.cn>
 <1720577870543075.69.seg@mailgw.kylinos.cn>
Content-Language: en-US
From: leixiang <leixiang@kylinos.cn>
In-Reply-To: <1720577870543075.69.seg@mailgw.kylinos.cn>

This is a multi-part message in MIME format.
--------------jkXOCQSioAPa8KmW3dL6up9P
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Dear Alex,
Thank you for your reply and suggestions.

On 2024/7/9 18:12, Alexandru Elisei wrote:
> Hi,
> 
> Adding the kvmtool maintainers (you can find them in the README file).
> 
> On Tue, Jun 18, 2024 at 03:52:47PM +0800, leixiang wrote:
>> Fix memory leakage in disk/core disk_image__open_all when malloc disk failed,
>> should free the disks that already malloced.
>>
>> Signed-off-by: Lei Xiang <leixiang@kylinos.cn>
>> Suggested-by: Xie Ming <xieming@kylinos.cn>
>> ---
>>  disk/core.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/disk/core.c b/disk/core.c
>> index dd2f258..affeece 100644
>> --- a/disk/core.c
>> +++ b/disk/core.c
>> @@ -195,8 +195,10 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
>>  
>>  		if (wwpn) {
>>  			disks[i] = malloc(sizeof(struct disk_image));
>> -			if (!disks[i])
>> -				return ERR_PTR(-ENOMEM);
>> +			if (!disks[i]) {
>> +				err = ERR_PTR(-ENOMEM);
>> +				goto error;
>> +			}
>>  			disks[i]->wwpn = wwpn;
>>  			disks[i]->tpgt = tpgt;
> 
> Currently, the latest patch on branch master is ca31abf5d9c3 ("arm64: Allow
> the user to select the max SVE vector length"), and struct disk_image
> doesn't have a tpgt field. Did you write this patch on a local branch?
> 
>>  			continue;
> 
There is no doubt that you are correct, I had realize that I git clone a wrong repo.
> This is what the 'error' label does:
> 
> error:
>         for (i = 0; i < count; i++)
>                 if (!IS_ERR_OR_NULL(disks[i]))
>                         disk_image__close(disks[i]);
> 
>         free(disks);
>         return err;
> 
> And disk_image__close() ends up poking all sort of fields from struct
> disk_image, including dereferencing pointers embedded in the struct. If
> WWPN is specified for a disk, struct disk_image is allocated using malloc
> as above, the field wwwpn is set and the rest of the fields are left
> uninitialized. Because of this, calling disk_image__close() on a struct
> disk_image with wwpn can lead to all sorts of nasty things happening.
> 
> May I suggest allocating disks[i] using calloc in the wwpn case to fix
> this? Ideally, you would have two patches:
> 
> 1. A patch that changes the disk[i] allocation to calloc(), to prevent
> disk_image__close() accessing unitialized fields when disk_image__open()
> fails after initialized a WWPN disk.
> 
> 2. This patch.
> 
When the new disk_image is allocated successfully, 
the fields will eventually be initialized by disk_image__new().
And disk_image__close() accessing fields also checked before use.
So I don't think it's necessary to replace malloc with calloc.
> Thanks,
> Alex
> 
>> -- 
>> 2.34.1
>>
>>
--------------jkXOCQSioAPa8KmW3dL6up9P
Content-Type: text/x-patch; charset=UTF-8;
 name="v2-0001-kvmtool-disk-core-Fix-memory-leakage-in-open-all-.patch"
Content-Disposition: attachment;
 filename*0="v2-0001-kvmtool-disk-core-Fix-memory-leakage-in-open-all-.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBkMWJhYmUyNTY5MDRhMjRmNGM5ZGNlZGQwNjNhN2Q1YWU5ZjQwOTI3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBsZWl4aWFuZyA8bGVpeGlhbmdAa3lsaW5vcy5jbj4K
RGF0ZTogV2VkLCAxMCBKdWwgMjAyNCAxNjowNjowMiArMDgwMApTdWJqZWN0OiBbUEFUQ0gg
djJdIGt2bXRvb2w6ZGlzay9jb3JlOkZpeCBtZW1vcnkgbGVha2FnZSBpbiBvcGVuIGFsbCBk
aXNrcwoKRml4IG1lbW9yeSBsZWFrYWdlIGluIGRpc2svY29yZSBkaXNrX2ltYWdlX19vcGVu
X2FsbCB3aGVuIG1hbGxvYyBkaXNrIGZhaWxlZCwKc2hvdWxkIGZyZWUgdGhlIGRpc2tzIHRo
YXQgYWxyZWFkeSBtYWxsb2NlZC4KClNpZ25lZC1vZmYtYnk6IExlaSBYaWFuZyA8bGVpeGlh
bmdAa3lsaW5vcy5jbj4KU3VnZ2VzdGVkLWJ5OiBYaWUgTWluZyA8eGllbWluZ0BreWxpbm9z
LmNuPgotLS0KIGRpc2svY29yZS5jIHwgNiArKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZGlzay9jb3JlLmMg
Yi9kaXNrL2NvcmUuYwppbmRleCBiMDBiMGMwLi5jZTIyMjRkIDEwMDY0NAotLS0gYS9kaXNr
L2NvcmUuYworKysgYi9kaXNrL2NvcmUuYwpAQCAtMTcxLDggKzE3MSwxMCBAQCBzdGF0aWMg
c3RydWN0IGRpc2tfaW1hZ2UgKipkaXNrX2ltYWdlX19vcGVuX2FsbChzdHJ1Y3Qga3ZtICpr
dm0pCiAKIAkJaWYgKHd3cG4pIHsKIAkJCWRpc2tzW2ldID0gbWFsbG9jKHNpemVvZihzdHJ1
Y3QgZGlza19pbWFnZSkpOwotCQkJaWYgKCFkaXNrc1tpXSkKLQkJCQlyZXR1cm4gRVJSX1BU
UigtRU5PTUVNKTsKKwkJCWlmICghZGlza3NbaV0pIHsKKwkJCQllcnIgPSBFUlJfUFRSKC1F
Tk9NRU0pOworCQkJCWdvdG8gIGVycm9yOworCQkJfQogCQkJZGlza3NbaV0tPnd3cG4gPSB3
d3BuOwogCQkJY29udGludWU7CiAJCX0KLS0gCjIuMzQuMQoK

--------------jkXOCQSioAPa8KmW3dL6up9P--

