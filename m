Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B8C36C86F
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 17:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbhD0PNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 11:13:38 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40397 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235466AbhD0PNh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 11:13:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A68BA19409C9;
        Tue, 27 Apr 2021 11:12:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 27 Apr 2021 11:12:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=P1Hqi4
        PHicAFs4lHLdN9ZUQdjcf++Px2mQGjk8ekmiA=; b=tVGOkxtuv0wyL7RxhgaPKC
        TRIxEl+J1wtc1S490MIOHDvQkwEN4ac9jgfGWxXyZz0Cu9CmMNkPsDDeDdp+sqL2
        Df5meflPbbNTffzTiaX4jBd5sb9GE2Pvy3aBnMsuse4r/J3/SOJPwp81ISIkG7G5
        CKbGW3tjVEBAzRKsjSDD3WhFPCNRalBrq3+BIC2R3CDwMvrLFBH2sjQSg+Vme2Ty
        n5MrR8OLOIaz7tdeu2YaUg7/JBl0X2hxa+ZGALgWH3FiHeItfLQqQ8s28G8cFa1v
        xorCvnTXALYkCcIhBk8nfXYxc7el8wzE+aJBIjoyaERvWS9qOfiYSLjh6AQXnwvw
        ==
X-ME-Sender: <xms:9CmIYBj27scQOjc1Es_1y5lFhxoPe22iJZ8tjJa5acihAKwyuurIlA>
    <xme:9CmIYGB07sdOhT-VUKxhIw5N19Tswx-Vo-vbe_b_CsP1YEFQIddZGJfOHKWuSd7K4
    8DhxVlir1uWVgKOjtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddvtddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucfk
    phepkedurddukeejrddviedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegumhgvsegumhgvrdhorhhg
X-ME-Proxy: <xmx:9CmIYBEl9twTwITE7c0sxQJxTYZTN50czE_0gvrMl-yXhPvVuw6YnA>
    <xmx:9CmIYGR6qmiaEedFWDfiaKMtfAHJuy5DZmlA7VQzxhRcftS-NBsvLA>
    <xmx:9CmIYOy4_4IOg114m78WKP1JrkSlwmBVcpsunZbYuOtWiZbec9F8_Q>
    <xmx:9SmIYJzWXU4pJWRRnxqnt5p0602gW2iPaxPdGlcR_N3Y7KGcRN6xlQ>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 27 Apr 2021 11:12:51 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 98a0580e;
        Tue, 27 Apr 2021 15:12:50 +0000 (UTC)
To:     Hikaru Nishida <hikalium@chromium.org>, kvm@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] x86/kvm: Reserve KVM_FEATURE_HOST_SUSPEND_TIME
 and MSR_KVM_HOST_SUSPEND_TIME
In-Reply-To: <20210426090644.2218834-2-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org>
 <20210426090644.2218834-2-hikalium@chromium.org>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Tue, 27 Apr 2021 16:12:50 +0100
Message-ID: <cunk0onkbgt.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, 2021-04-26 at 18:06:40 +09, Hikaru Nishida wrote:

> No functional change; just add documentation for
> KVM_FEATURE_HOST_SUSPEND_TIME and its corresponding
> MSR_KVM_HOST_SUSPEND_TIME to support virtual suspend timing injection in
> later patches.
>
> Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
> ---
>
>  Documentation/virt/kvm/cpuid.rst |  3 +++
>  Documentation/virt/kvm/msr.rst   | 29 +++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
>
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index cf62162d4be2..c7cb581b9a9b 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -96,6 +96,9 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
>                                                 before using extended destination
>                                                 ID bits in MSI address bits 11-5.
>  
> +KVM_FEATURE_HOST_SUSPEND_TIME      16          host suspend time information
> +                                               is available at msr 0x4b564d08.
> +
>  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                 per-cpu warps are expected in
>                                                 kvmclock
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index e37a14c323d2..de96743245c9 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -376,3 +376,32 @@ data:
>  	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
>  	and check if there are more notifications pending. The MSR is available
>  	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> +
> +MSR_KVM_HOST_SUSPEND_TIME:
> +	0x4b564d08
> +
> +data:
> +	8-byte alignment physical address of a memory area which must be
> +	in guest RAM, plus an enable bit in bit 0. This memory is expected to
> +	hold a copy of the following structure::
> +
> +	 struct kvm_host_suspend_time {
> +		__u64   suspend_time_ns;
> +	 };
> +
> +	whose data will be filled in by the hypervisor.
> +	If the guest register this structure through the MSR write, the host
> +	will stop all the clocks including TSCs observed by the guest during
> +	the host's suspension and report the duration of suspend through this
> +	structure. Fields have the following meanings:
> +
> +	host_suspend_time_ns:

s/host_suspend_time_ns/suspend_time_ns/

> +		Total number of nanoseconds passed during the host's suspend
> +		while the VM is running. This value will be increasing
> +		monotonically.
> +
> +	Note that although MSRs are per-CPU entities, the effect of this
> +	particular MSR is global.
> +
> +	Availability of this MSR must be checked via bit 16 in 0x4000001 cpuid
> +	leaf prior to usage.
> -- 
> 2.31.1.498.g6c1eba8ee3d-goog

dme.
-- 
I do believe it's Madame Joy.
