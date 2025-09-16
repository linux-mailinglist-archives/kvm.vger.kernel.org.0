Return-Path: <kvm+bounces-57800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E782B7DE23
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:36:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F1DB32511A
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7BC2D3ED2;
	Tue, 16 Sep 2025 23:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redadmin.org header.i=@redadmin.org header.b="oz5GUvGS"
X-Original-To: kvm@vger.kernel.org
Received: from www.redadmin.org (ag129037.ppp.asahi-net.or.jp [157.107.129.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D481F4701;
	Tue, 16 Sep 2025 23:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=157.107.129.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758065986; cv=pass; b=tE/7gNqdDxwSz0ZOYnY9zj6d5foFgDgviBBSKaF2nixnHqj4O+Eell3pZ42TOUmClYSuAI/sR1nrumqG/dwSmvvjTAQ98shwulJKfvS020WXEn8G4AP8lroIxTFQNLHsJc3ba/VUk116nzS6UMfmvAceKstkBsuaxmNLRkkNKgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758065986; c=relaxed/simple;
	bh=PFsoJQKsPOMTHBjFZPpV9hcgwDa9sL0vhxEZilWRMgo=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=YOa7hlvMrijBaT1bJ4XUEufJx21/cxEBVpZN7+8tkVC4HhNF+1XXRTYT4xWcA0pWETWqwKOwPrWYoD7kvPS/pC8XSr2MMSF5aJUiLThv5MPEztEQHaW7nEdDeL5TUsW77t9cw8OXskt+nCAIyi10+NyVOQ02ZQXE7KMG76GZk30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redadmin.org; spf=pass smtp.mailfrom=redadmin.org; dkim=pass (1024-bit key) header.d=redadmin.org header.i=@redadmin.org header.b=oz5GUvGS; arc=pass smtp.client-ip=157.107.129.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redadmin.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redadmin.org
Received: from localhost (localhost [127.0.0.1])
	by www.redadmin.org (Postfix) with ESMTP id 92B6E10A40A15;
	Wed, 17 Sep 2025 08:39:34 +0900 (JST)
X-Virus-Scanned: amavis at redadmin.org
Received: from www.redadmin.org ([127.0.0.1])
 by localhost (redadmin.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id X-ez8NUZDHzX; Wed, 17 Sep 2025 08:39:30 +0900 (JST)
Received: from webmail.redadmin.org (redadmin.org [192.168.11.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: weibu@redadmin.org)
	by www.redadmin.org (Postfix) with ESMTPSA id 05504109D55C5;
	Wed, 17 Sep 2025 08:39:30 +0900 (JST)
DMARC-Filter: OpenDMARC Filter v1.4.2 www.redadmin.org 05504109D55C5
Authentication-Results: www.redadmin.org; arc=none smtp.remote-ip=192.168.11.50
ARC-Seal: i=1; a=rsa-sha256; d=redadmin.org; s=20231208space; t=1758065970;
	cv=none; b=bjCczSjfmxObxUTNgqjEpei+4R0BahKXFWqYiHqPxtg3P09QX/Dhcu+4vKFUle226yrGfD0UBJlLanxyqroq+L7UkaZtRoXUmjzEk3zFyA3ub5Us7tD8eC8wjMkusBxin5KkXNbWLYrKEaw4vA1rglDmnFZOzGOSXW1CoEbdHJk=
ARC-Message-Signature: i=1; a=rsa-sha256; d=redadmin.org; s=20231208space;
	t=1758065970; c=relaxed/relaxed;
	bh=3rQK+DBBPyMcARL0z/kIhvopLlplPjKFYeDcfVSaDYQ=;
	h=DKIM-Filter:DKIM-Signature:MIME-Version:Date:From:To:Cc:Subject:
	 In-Reply-To:References:Message-ID:X-Sender:Content-Type:
	 Content-Transfer-Encoding; b=TuddA/DzD2XRk7S/9SVAFkU72zvEdct+WWLb0lmzbRpO0FgPFcFfue2pPrtOwmsCdC/SDDeNlRsEkD4XvkdpwMSVAycT7SWbcR4NY1zziAPRfc7sMwqW2sSwsxouxfMF9qjV1/agxCzjEVjp9BJVydI54LEVu/G5az0RG9F2BaY=
ARC-Authentication-Results: i=1; www.redadmin.org
DKIM-Filter: OpenDKIM Filter v2.11.0 www.redadmin.org 05504109D55C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redadmin.org;
	s=20231208space; t=1758065970;
	bh=3rQK+DBBPyMcARL0z/kIhvopLlplPjKFYeDcfVSaDYQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oz5GUvGSH/48oSZeUxsnrbB8+YuPEXKeqxhuRJLfbh821RcFQesENUjaJBThqmtAs
	 NvRDuX46a5Tlraa3jCPWB6ahyiOJLNxtrB+gRb0wxarker8pDdMW/AprzkdFtVAAr2
	 5YXf9pIv3XwW3l0YeuM7fpT3XWmnhqzls4g3jVR4=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 17 Sep 2025 08:39:29 +0900
From: weibu@redadmin.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: wmi: lenovo-wmi-gamezone: fix typo in frequency
In-Reply-To: <877bxyfkw7.fsf@trenco.lwn.net>
References: <20250913173845.951982-1-weibu@redadmin.org>
 <877bxyfkw7.fsf@trenco.lwn.net>
Message-ID: <a88c47e98139a6264670879407fb09a3@redadmin.org>
X-Sender: weibu@redadmin.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

Hi Jon,

You’re right — that block is a verbatim MOF listing decoded by bmfdec, 
and the misspelling comes from the vendor-provided Description string. 
So this isn’t an editing error in the docs.

I’ll drop this patch. If it helps future readers, I can send a follow-up 
that adds a short note saying the MOF listing is verbatim and typos are 
preserved.

Thanks for the careful review!

Akiyoshi

2025-09-17 00:59 に Jonathan Corbet さんは書きました:
> Akiyoshi Kurita <weibu@redadmin.org> writes:
> 
>> Fix a spelling mistake in lenovo-wmi-gamezone.rst
>> ("freqency" -> "frequency").
>> 
>> No functional change.
>> 
>> Signed-off-by: Akiyoshi Kurita <weibu@redadmin.org>
>> ---
>>  Documentation/wmi/devices/lenovo-wmi-gamezone.rst | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/wmi/devices/lenovo-wmi-gamezone.rst 
>> b/Documentation/wmi/devices/lenovo-wmi-gamezone.rst
>> index 997263e51a7d..167548929ac2 100644
>> --- a/Documentation/wmi/devices/lenovo-wmi-gamezone.rst
>> +++ b/Documentation/wmi/devices/lenovo-wmi-gamezone.rst
>> @@ -153,7 +153,7 @@ data using the `bmfdec 
>> <https://github.com/pali/bmfdec>`_ utility:
>>      [WmiDataId(1), read, Description("P-State ID.")] uint32 PStateID;
>>      [WmiDataId(2), read, Description("CLOCK ID.")] uint32 ClockID;
>>      [WmiDataId(3), read, Description("Default value.")] uint32 
>> defaultvalue;
>> -    [WmiDataId(4), read, Description("OC Offset freqency.")] uint32 
>> OCOffsetFreq;
>> +    [WmiDataId(4), read, Description("OC Offset frequency")] uint32 
>> OCOffsetFreq;
>>      [WmiDataId(5), read, Description("OC Min offset value.")] uint32 
>> OCMinOffset;
> 
> I don't have the device in question and can't test this ... but the 
> text
> in question has the appearance of being literal output from the bmfdec
> utility.  Do we know that this is some sort of editing error rather 
> than
> an accurate reflection of what the tool prints?
> 
> Thanks,
> 
> jon

