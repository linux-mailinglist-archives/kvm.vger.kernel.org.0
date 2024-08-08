Return-Path: <kvm+bounces-23601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1792E94B71D
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 09:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9104285A4F
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 07:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F35D18800A;
	Thu,  8 Aug 2024 07:07:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105A47464
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 07:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723100860; cv=none; b=mqu2aJA7eZcKirB23CFb8FGyuWpzWueXnKTRlRSe5KkFC1jrj6NU5RaBmvPUwCKAhQoQJGAyMdiASRLqgnnOR8dE8QgxHUqqM4m777uxKjnr2NVD1/Xv+9RX11VDJfXtstVcoYKSljRLnhQrx9yNWFU++Hcdv1SZRYyROdZme7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723100860; c=relaxed/simple;
	bh=F/6oajmcT92xVQC+qqfv5Pi+rHH6IPCa7muJYlsNZlY=;
	h=Content-Type:Message-ID:Date:MIME-Version:From:Subject:To:Cc:
	 References:In-Reply-To; b=srhp4exG1/BjCzS9Jm0xsaF8za98r9ps9Shh9gJnGNfBEdmPL9KGwOb3D28EPiTKa0M2hOm8iZ9/UXL2RNF7pOzZdn8tCqKB9ZO5MjCZOKFAe7H38UnHJqdgxZNXY1C6WUNrULHg7TlL6oHNUlQAfATmau5wsHlq3wV8uooFkcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: dfeb42b6555411efa216b1d71e6e1362-20240808
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:634d81bf-611d-4595-9371-623009b3347d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:5,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:82c5f88,CLOUDID:e6fc08a567c8f2d48bed07968466cf91,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,URL:0
	,File:2,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
	,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: dfeb42b6555411efa216b1d71e6e1362-20240808
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <leixiang@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1742927624; Thu, 08 Aug 2024 15:07:29 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 3E862E000EBC;
	Thu,  8 Aug 2024 15:07:29 +0800 (CST)
X-ns-mid: postfix-66B46EB1-155400331
Received: from [10.42.12.63] (unknown [10.42.12.63])
	by mail.kylinos.cn (NSMail) with ESMTPA id C67E2E000EBC;
	Thu,  8 Aug 2024 15:07:28 +0800 (CST)
Content-Type: multipart/mixed; boundary="------------0o2HP2qYZmRF4MjzaiOWMF3n"
Message-ID: <65abd5e3-4501-42b8-aee1-4cc8aa4009b3@kylinos.cn>
Date: Thu, 8 Aug 2024 15:07:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: leixiang <leixiang@kylinos.cn>
Subject: Re: [PATCH] kvm tools:Fix memory leakage in open all disks
To: Alexandru Elisei <alexandru.elisei@arm.com>, Will Deacon <will@kernel.org>
Cc: julien.thierry.kdev@gmail.com, kvm@vger.kernel.org, xieming@kylinos.cn
References: <20240618075247.1394144-1-leixiang@kylinos.cn>
 <1720577870543075.69.seg@mailgw.kylinos.cn>
 <c651de19-4346-4be9-afe5-16427015680f@kylinos.cn> <Zo5GDbKDYmY4uPYz@arm.com>
 <bc4212f7-95d8-428a-95fc-f6c8e017cbe5@kylinos.cn>
 <20240805122749.GA9326@willie-the-truck> <ZrIblC5csf73sWvi@arm.com>
Content-Language: en-US
In-Reply-To: <ZrIblC5csf73sWvi@arm.com>

This is a multi-part message in MIME format.
--------------0o2HP2qYZmRF4MjzaiOWMF3n
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I also think this modification suggestion is better.
So I incorporated the modification suggestions into the patch,
hoping to be accepted.

On 2024/8/6 20:48, Alexandru Elisei wrote:
> Hi Will,
> 
> On Mon, Aug 05, 2024 at 01:27:49PM +0100, Will Deacon wrote:
>> On Wed, Jul 10, 2024 at 06:00:53PM +0800, leixiang wrote:
>>> From 56b60cf70a0c5f7cdafe6804dabbe7112c10f7a1 Mon Sep 17 00:00:00 2001
>>> From: leixiang <leixiang@kylinos.cn>
>>> Date: Wed, 10 Jul 2024 17:45:51 +0800
>>> Subject: [PATCH v3] kvmtool:disk/core:Fix memory leakage in open all disks
>>>
>>> Fix memory leakage in disk/core disk_image__open_all when malloc disk failed,
>>> should free the disks that already malloced.
>>> And to avoid fields not being initialized in struct disk_image,
>>> replace malloc with calloc.
>>>
>>> Signed-off-by: Lei Xiang <leixiang@kylinos.cn>
>>> Suggested-by: Xie Ming <xieming@kylinos.cn>
>>> ---
>>>  disk/core.c | 8 +++++---
>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/disk/core.c b/disk/core.c
>>> index b00b0c0..a084cd4 100644
>>> --- a/disk/core.c
>>> +++ b/disk/core.c
>>> @@ -170,9 +170,11 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
>>>  		wwpn = params[i].wwpn;
>>>  
>>>  		if (wwpn) {
>>> -			disks[i] = malloc(sizeof(struct disk_image));
>>> -			if (!disks[i])
>>> -				return ERR_PTR(-ENOMEM);
>>> +			disks[i] = calloc(1, sizeof(struct disk_image));
>>> +			if (!disks[i]) {
>>> +				err = ERR_PTR(-ENOMEM);
>>> +				goto error;
>>> +			}
>>>  			disks[i]->wwpn = wwpn;
>>>  			continue;
>>
>> Hmm, I'm still not sure about this. I don't think we should call
>> disk_image__close() for disks that weren't allocated via
>> disk_image__open(). Using calloc() might work, but it feels fragile.
>>
>> Instead, can we change the error handling to do something like below?
>>
>> Will
>>
>> --->8
>>
>> diff --git a/disk/core.c b/disk/core.c
>> index b00b0c0..b543d44 100644
>> --- a/disk/core.c
>> +++ b/disk/core.c
>> @@ -171,8 +171,11 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
>>  
>>                 if (wwpn) {
>>                         disks[i] = malloc(sizeof(struct disk_image));
>> -                       if (!disks[i])
>> -                               return ERR_PTR(-ENOMEM);
>> +                       if (!disks[i]) {
>> +                               err = ERR_PTR(-ENOMEM);
>> +                               goto error;
>> +                       }
>> +
>>                         disks[i]->wwpn = wwpn;
>>                         continue;
>>                 }
>> @@ -191,9 +194,15 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
>>  
>>         return disks;
>>  error:
>> -       for (i = 0; i < count; i++)
>> -               if (!IS_ERR_OR_NULL(disks[i]))
>> +       for (i = 0; i < count; i++) {
>> +               if (IS_ERR_OR_NULL(disks[i]))
>> +                       continue;
>> +
>> +               if (disks[i]->wwpn)
>> +                       free(disks[i]);
>> +               else
>>                         disk_image__close(disks[i]);
>> +       }
>>  
>>         free(disks);
>>         return err;
>>
>>
>>>  		}
> 
> This looks much better than my suggestion.
> 
> Thanks,
> Alex
--------------0o2HP2qYZmRF4MjzaiOWMF3n
Content-Type: text/x-patch; charset=UTF-8;
 name="v4-0001-kvmtool-disk-core-Fix-memory-leakage-in-open-all-.patch"
Content-Disposition: attachment;
 filename*0="v4-0001-kvmtool-disk-core-Fix-memory-leakage-in-open-all-.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBmOWViYmU0MTJjZmZhZmJmMDZjNzM4MzM2ZWU0NTk0MmQ3YzE5NzdmIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBsZWl4aWFuZyA8bGVpeGlhbmdAa3lsaW5vcy5jbj4K
RGF0ZTogV2VkLCAxMCBKdWwgMjAyNCAxNzo0NTo1MSArMDgwMApTdWJqZWN0OiBbUEFUQ0gg
djRdIGt2bXRvb2w6ZGlzay9jb3JlOkZpeCBtZW1vcnkgbGVha2FnZSBpbiBvcGVuIGFsbCBk
aXNrcwoKRml4IG1lbW9yeSBsZWFrYWdlIGluIGRpc2svY29yZSBkaXNrX2ltYWdlX19vcGVu
X2FsbCB3aGVuIG1hbGxvYyBkaXNrIGZhaWxlZCwKc2hvdWxkIGZyZWUgdGhlIGRpc2tzIHRo
YXQgYWxyZWFkeSBtYWxsb2NlZC4KClNpZ25lZC1vZmYtYnk6IExlaSBYaWFuZyA8bGVpeGlh
bmdAa3lsaW5vcy5jbj4KU3VnZ2VzdGVkLWJ5OiBYaWUgTWluZyA8eGllbWluZ0BreWxpbm9z
LmNuPgpTdWdnZXN0ZWQtYnk6IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlA
YXJtLmNvbT4KU3VnZ2VzdGVkLWJ5OiBXaWxsIERlYWNvbiA8d2lsbEBrZXJuZWwub3JnPgot
LS0KIGRpc2svY29yZS5jIHwgMTcgKysrKysrKysrKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAxMiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Rpc2sv
Y29yZS5jIGIvZGlzay9jb3JlLmMKaW5kZXggYjAwYjBjMC4uOTFkYjI3NyAxMDA2NDQKLS0t
IGEvZGlzay9jb3JlLmMKKysrIGIvZGlzay9jb3JlLmMKQEAgLTE3MSw4ICsxNzEsMTAgQEAg
c3RhdGljIHN0cnVjdCBkaXNrX2ltYWdlICoqZGlza19pbWFnZV9fb3Blbl9hbGwoc3RydWN0
IGt2bSAqa3ZtKQogCiAJCWlmICh3d3BuKSB7CiAJCQlkaXNrc1tpXSA9IG1hbGxvYyhzaXpl
b2Yoc3RydWN0IGRpc2tfaW1hZ2UpKTsKLQkJCWlmICghZGlza3NbaV0pCi0JCQkJcmV0dXJu
IEVSUl9QVFIoLUVOT01FTSk7CisJCQlpZiAoIWRpc2tzW2ldKSB7CisJCQkJZXJyID0gRVJS
X1BUUigtRU5PTUVNKTsKKwkJCQlnb3RvIGVycm9yOworCQkJfQogCQkJZGlza3NbaV0tPnd3
cG4gPSB3d3BuOwogCQkJY29udGludWU7CiAJCX0KQEAgLTE5MSwxMCArMTkzLDE1IEBAIHN0
YXRpYyBzdHJ1Y3QgZGlza19pbWFnZSAqKmRpc2tfaW1hZ2VfX29wZW5fYWxsKHN0cnVjdCBr
dm0gKmt2bSkKIAogCXJldHVybiBkaXNrczsKIGVycm9yOgotCWZvciAoaSA9IDA7IGkgPCBj
b3VudDsgaSsrKQotCQlpZiAoIUlTX0VSUl9PUl9OVUxMKGRpc2tzW2ldKSkKLQkJCWRpc2tf
aW1hZ2VfX2Nsb3NlKGRpc2tzW2ldKTsKKwlmb3IgKGkgPSAwOyBpIDwgY291bnQ7IGkrKykg
eworCQlpZiAoSVNfRVJSX09SX05VTEwoZGlza3NbaV0pKQorCQkJY29udGludWU7CiAKKwkJ
aWYgKGRpc2tzW2ldLT53d3BuKQorCQkJZnJlZShkaXNrc1tpXSk7CisJCWVsc2UKKwkJCWRp
c2tfaW1hZ2VfX2Nsb3NlKGRpc2tzW2ldKTsKKwl9CiAJZnJlZShkaXNrcyk7CiAJcmV0dXJu
IGVycjsKIH0KLS0gCjIuMzQuMQoK

--------------0o2HP2qYZmRF4MjzaiOWMF3n--

