Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4563062CF
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 18:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344319AbhA0R55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:57:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344040AbhA0R5s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:57:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611770182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YgG+QDM5pkstFzGqV9mKJs9XdzX4nzUkQb+n0L09tGQ=;
        b=cG3P75SdScfkLEmd27BfEO9O1fA99KggwRPBU1scXyp7Mmysu3NQv/b2kSvzMesT04Dafk
        +Sme84vq0ID3NJNqmdlO2s5yDf54kIdk0jmDfqfyoe6DW4g+hfcpirIL5TIfvK1pHuu9Qk
        JlwkmXh1FKmNLEOnGIXn0Z6+iHk4n+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-7m70NSHFOzyDteCqWKt7vA-1; Wed, 27 Jan 2021 12:56:18 -0500
X-MC-Unique: 7m70NSHFOzyDteCqWKt7vA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5659D801FCC;
        Wed, 27 Jan 2021 17:56:16 +0000 (UTC)
Received: from [10.36.113.217] (ovpn-113-217.ams2.redhat.com [10.36.113.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 095AD60BF3;
        Wed, 27 Jan 2021 17:56:13 +0000 (UTC)
Subject: Re: [PATCH v2 7/7] KVM: arm64: Use symbolic names for the PMU
 versions
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-8-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <6c6252b9-405e-ca35-4be2-8c1e646ce64b@redhat.com>
Date:   Wed, 27 Jan 2021 18:56:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210125122638.2947058-8-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/25/21 1:26 PM, Marc Zyngier wrote:
> Instead of using a bunch of magic numbers, use the existing definitions
> that have been added since 8673e02e58410 ("arm64: perf: Add support
> for ARMv8.5-PMU 64-bit counters")
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 72cd704a8368..cb16ca2eee92 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -23,11 +23,11 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
>  static u32 kvm_pmu_event_mask(struct kvm *kvm)
>  {
>  	switch (kvm->arch.pmuver) {
> -	case 1:			/* ARMv8.0 */
> +	case ID_AA64DFR0_PMUVER_8_0:
>  		return GENMASK(9, 0);
> -	case 4:			/* ARMv8.1 */
> -	case 5:			/* ARMv8.4 */
> -	case 6:			/* ARMv8.5 */
> +	case ID_AA64DFR0_PMUVER_8_1:
> +	case ID_AA64DFR0_PMUVER_8_4:
> +	case ID_AA64DFR0_PMUVER_8_5:
>  		return GENMASK(15, 0);
>  	default:		/* Shouldn't be here, just for sanity */
>  		WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

