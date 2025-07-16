Return-Path: <kvm+bounces-52625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7223DB074D5
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:33:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D04C61C26403
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179D72F3C13;
	Wed, 16 Jul 2025 11:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="mZKsqwvN"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A632C3266
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752665584; cv=none; b=XuFeYpJJ9OU9bwU5/UqGI8PXxUKlL4TL9R2E1s/Vc8cYxPejmvcy/n2gR4i+Rg4s4y2+wfFBGNCfQ4usiLX4cimeJajcc7wQ2f+ndVgl4mCky2VfZygFxxTwEMR9+nBXtZEvM9wkOWTgr7RrEj6Fo3KCN5xyzBXfwDpH/s0SQ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752665584; c=relaxed/simple;
	bh=LZPkWcWHnR+G7Qdbc5wssgh+rbZwcFxD66BOfgBJHq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IMuZh1TVirqnVhzmxnOwCYA5Tf1dIZbZm3o1iLl0007+GpIjq9S8+cjNJU0F7htaJPJlzrB9yGBxAXe99SnSL6Mb0UFiMV3ZhlK5a3lwF213QRmZczD/4ih3sxMPXXkUoNaKKp00IH2yHsAbuKx/ULdmOGqjpy61OiK+hgWL+Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=mZKsqwvN reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [157.82.206.39] ([157.82.206.39])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56GBWqxB026035
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 16 Jul 2025 20:32:52 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=ICTS1Ps0EN4b96NtX6XGLQlHBYf4LG/YqpIJ5KhSIUo=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752665572; v=1;
        b=mZKsqwvN1S8meHTxAObOEVF3Zxy+Szlfym3D07WhtRGxYD10NZwmjTb2U8JJJClF
         2V2fjZdZgydkpgrefVKcEjybs1JiBVJ/fdBb6NKVZ3qhxV0f7CE4xUtCDQfwLoeD
         EGKwiWvH3+w/yA9eK1skzXaOq4pFIbU1D5lEgyWVdKpEUjEi+qWs93O1/Pj/9b8f
         v71cuBQiqLCNryi3LF1Wb5EPRWEHARzg0HS5j+wwBOEJrXLU4nE+2ZGaXaHeTFXt
         TO2N7wJvTtRugyYX6yWDjZu0v4IrZ5FILnQEw8IWxxYHxfU89N3NBTPuOgx2lNyy
         B0givpv91oc52nHeu1C1Vg==
Message-ID: <f2674001-9489-44c9-b17a-c9d8a66b3935@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 16 Jul 2025 20:32:52 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 01/13] net: bundle all offloads in a single struct
To: Paolo Abeni <pabeni@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Jason Wang
 <jasowang@redhat.com>,
        Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Luigi Rizzo <lrizzo@google.com>,
        Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>,
        Vincenzo Maffione <v.maffione@gmail.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <6e85b684df9f953f04b10c75288e2d4065af49a2.1752229731.git.pabeni@redhat.com>
 <d434b098-aebc-42cb-b589-d84f7bd78c21@rsg.ci.i.u-tokyo.ac.jp>
 <bbf7744c-9340-4d59-804b-87f7ff9bdcc4@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <bbf7744c-9340-4d59-804b-87f7ff9bdcc4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/07/15 23:52, Paolo Abeni wrote:
> On 7/15/25 8:36 AM, Akihiko Odaki wrote:
>> On 2025/07/11 22:02, Paolo Abeni wrote:
>>> The set_offload() argument list is already pretty long and
>>> we are going to introduce soon a bunch of additional offloads.
>>>
>>> Replace the offload arguments with a single struct and update
>>> all the relevant call-sites.
>>>
>>> No functional changes intended.
>>>
>>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>>> ---
>>> Note: I maintained  the struct usage as opposed to uint64_t bitmask usage
>>> as suggested by Akihiko, because the latter feel a bit more invasive.
>>
>> I think a bitmask will be invasive to the same extent with the current
>> version; most part of this change comes from the parameter passing,
>> which does not depend on the representation of the parameter.
> 
> Do you have strong feeling WRT the bitmask usage?
> 
> Another argument vs the bitmask usage is that it will requires some
> extra input validation of the selected offload bits (most of them don't
> make sense in this context).

I don't think such a validation is necessary.

There is practically no chance to have a wrong bit set by mistake when 
callers specify bits with macros prefixed with VIRTIO_NET_O_GUEST_. 
There will be a compilation error if the caller specify a offload bit 
that doesn't exist.

It is also obvious if a caller specified something unrelated (i.e., not 
prefixed with VIRTIO_NET_O_GUEST_). A real downside here would be that 
we will need to type VIRTIO_NET_O_GUEST_ each time referring an offload 
bit; such a redundancy does not exist with struct because the type 
system knows the bits bound to the type.

That said, 1) I prefer bitmasks much over struct though 2) I will be in 
favor of merging this series if everything else gets sorted out while 
the struct remains.

I'll explain the reason for 1) first:

There are both a downside and an upside with bitmasks. The downside is 
the redundancy of syntax, which I have just pointed out. The upside is 
the consistency with virtio's offload configuration, which defines the 
functionality of set_offload().

I consider the following two factors in such a trade-off scenario:
a) The balance between the downside and upside
b) Prior examples in the code base

Regarding a), I think the upside outweighs the downside but its extent 
is small.

b) matters more for this particular case; there are bunch of examples 
that use bitmasks in "include", excluding "include/hw" but there are 
none of structs that are dedicated for bools. Consistency matters for a 
big code base like QEMU so I want a good reason when making an exception.

The reasoning behind 2) is that having this patch is still better than 
the status quo.

Regards,
Akihiko Odaki

