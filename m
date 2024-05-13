Return-Path: <kvm+bounces-17327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 802188C440D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BFE22871A8
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 15:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10A51EB37;
	Mon, 13 May 2024 15:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWKuGcoI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF76539C;
	Mon, 13 May 2024 15:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715613563; cv=none; b=b0+48fHx4yuKKl580lU7Mn599b4BF0ySg+axJ8ewhDpXmJo/X4B1OpZ8Jo3GZP7/lvmgvCgtAf4hlGSfp4EZEMloE5575ww9scnEi2fXBhh5RP8FMDSKvPxvnv92jZaFKZ07fuSyO3ckN6Jn6tCR+635F7UrYTqhwJX0VnA4vIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715613563; c=relaxed/simple;
	bh=wHj1VNy0vMRh33TWNtQHJRbW6jcVnhuKzLbGW57DgDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0jzPJ3BgWrhj1ae43ifHXXVX63O4SJoTODb7c0GmamchGSo4O2DCelkdxsjP+rkBXkv5iWru2eD0XxN0lmvEEy4Ch9W8lX6rFAd34iO9WaPrBrl2E4j1wbQQ7FBqi5jzZ0/MEwzRs85p90mjerJhf6R61g+Aj7wWORLc8SNGZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWKuGcoI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869AAC113CC;
	Mon, 13 May 2024 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715613562;
	bh=wHj1VNy0vMRh33TWNtQHJRbW6jcVnhuKzLbGW57DgDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CWKuGcoI+uzQLcGuTk4s9n/ib+KqkgH4AmATgPGB9VqtVKSUGaPwHGNAerJhgqu8V
	 IqFSYYQNRyMi6FRj02UBx/xXPqUe2WUiCWefGBK0Ohn1jg+FEPM/+0UXWaf2kPnpWW
	 aPwZUZsWEGWbMu5CWSOG8Q0GJuLDUhYnWXGWz06GI+fkYLezXNstuSmdLRNFwWZI7f
	 ekJl4JI5JrsbUXVwxEOhky9Hb4G/08XMYtzr/lQ9eJCfy91aC4gKQG/JSIpI2liY3g
	 XzC97YYKQneJOoZcRk/jdKmD4ExONKysrIX93rQH1pT1pQHGorsiwp0kG8udoMD2/+
	 6WzefNR6Acfgw==
Date: Mon, 13 May 2024 08:19:20 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>, llvm@lists.linux.dev
Subject: Re: [PULL 18/19] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
Message-ID: <20240513151920.GA3061950@thelio-3990X>
References: <20240510211024.556136-1-michael.roth@amd.com>
 <20240510211024.556136-19-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510211024.556136-19-michael.roth@amd.com>

Hi Michael,

On Fri, May 10, 2024 at 04:10:23PM -0500, Michael Roth wrote:
> Version 2 of GHCB specification added support for the SNP Extended Guest
> Request Message NAE event. This event serves a nearly identical purpose
> to the previously-added SNP_GUEST_REQUEST event, but allows for
> additional certificate data to be supplied via an additional
> guest-supplied buffer to be used mainly for verifying the signature of
> an attestation report as returned by firmware.
> 
> This certificate data is supplied by userspace, so unlike with
> SNP_GUEST_REQUEST events, SNP_EXTENDED_GUEST_REQUEST events are first
> forwarded to userspace via a KVM_EXIT_VMGEXIT exit structure, and then
> the firmware request is made after the certificate data has been fetched
> from userspace.
> 
> Since there is a potential for race conditions where the
> userspace-supplied certificate data may be out-of-sync relative to the
> reported TCB or VLEK that firmware will use when signing attestation
> reports, a hook is also provided so that userspace can be informed once
> the attestation request is actually completed. See the updates to
> Documentation/ for more details on these aspects.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Message-ID: <20240501085210.2213060-20-michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
...
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 00d29d278f6e..398266bef2ca 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
...
> +static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
> +{
> +	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	unsigned long data_npages;
> +	sev_ret_code fw_err;
> +	gpa_t data_gpa;
> +
> +	if (!sev_snp_guest(vcpu->kvm))
> +		goto abort_request;
> +
> +	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> +	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> +
> +	if (!IS_ALIGNED(data_gpa, PAGE_SIZE))
> +		goto abort_request;
> +
> +	/*
> +	 * Grab the certificates from userspace so that can be bundled with
> +	 * attestation/guest requests.
> +	 */
> +	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
> +	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_REQ_CERTS;
> +	vcpu->run->vmgexit.req_certs.data_gpa = data_gpa;
> +	vcpu->run->vmgexit.req_certs.data_npages = data_npages;
> +	vcpu->run->vmgexit.req_certs.flags = 0;
> +	vcpu->run->vmgexit.req_certs.status = KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING;
> +	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_req;
> +
> +	return 0; /* forward request to userspace */
> +
> +abort_request:
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
> +	return 1; /* resume guest */
> +}

This patch is now in -next as commit 32fde9e18b3f ("KVM: SEV: Provide
support for SNP_EXTENDED_GUEST_REQUEST NAE event"), where it causes a
clang warning (or hard error when CONFIG_WERROR is enabled):

  arch/x86/kvm/svm/sev.c:4078:67: error: variable 'fw_err' is uninitialized when used here [-Werror,-Wuninitialized]
   4078 |         ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
        |                                                                          ^~~~~~
  include/uapi/linux/sev-guest.h:94:24: note: expanded from macro 'SNP_GUEST_ERR'
     94 |                                          SNP_GUEST_FW_ERR(fw_err))
        |                                                           ^~~~~~
  include/uapi/linux/sev-guest.h:92:32: note: expanded from macro 'SNP_GUEST_FW_ERR'
     92 | #define SNP_GUEST_FW_ERR(x)             ((x) & SNP_GUEST_FW_ERR_MASK)
        |                                           ^
  arch/x86/kvm/svm/sev.c:4051:2: note: variable 'fw_err' is declared here
   4051 |         sev_ret_code fw_err;
        |         ^
  1 error generated.

Seems legitimate to me. What was the intention here?

Cheers,
Nathan

