Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EC1305E4A
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 15:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhA0O3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 09:29:13 -0500
Received: from foss.arm.com ([217.140.110.172]:48910 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233913AbhA0O2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 09:28:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39CCF1FB;
        Wed, 27 Jan 2021 06:27:56 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05E393F68F;
        Wed, 27 Jan 2021 06:27:54 -0800 (PST)
Subject: Re: [PATCH v2 7/7] KVM: arm64: Use symbolic names for the PMU
 versions
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-8-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7aba2717-6c10-1335-0d94-5b96d93b9ade@arm.com>
Date:   Wed, 27 Jan 2021 14:28:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125122638.2947058-8-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

This is a nice cleanup. Checked that the defines have the same value as the
constants they are replacing:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

On 1/25/21 12:26 PM, Marc Zyngier wrote:
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
