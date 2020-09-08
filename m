Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989C1260F7F
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 12:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgIHKQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 06:16:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32701 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728876AbgIHKQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 06:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599560210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=2U0SK/7FKkBbAxLOPksJ7s9Y9mi4SDinpzWtL71Uh2g=;
        b=b8f2kP6v6EIf4YELjlZwFu+btgfeBVp1P2fehDo63CBXWpat0+c7LsNN4NWpDbZP6U+ekk
        DlHJLJR6wBR7vY/EiG4m25auBDbwrEL2DG0+R6iUYtsbvxeKnmEhNuvpJbC5Te0VARFDiM
        ULNBMOYj9zplwMxjS+ywRXEDimsDcIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-iYJiZG4sOIOFPG28N8YmAA-1; Tue, 08 Sep 2020 06:16:47 -0400
X-MC-Unique: iYJiZG4sOIOFPG28N8YmAA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3241802B60;
        Tue,  8 Sep 2020 10:16:45 +0000 (UTC)
Received: from [10.36.115.46] (ovpn-115-46.ams2.redhat.com [10.36.115.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE67E5C1BB;
        Tue,  8 Sep 2020 10:16:42 +0000 (UTC)
Subject: Re: [PATCH v3] KVM: s390: Introduce storage key removal facility
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20200908100249.23150-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <c926c50b-f161-03b0-18f5-ac3f01b7f9d9@redhat.com>
Date:   Tue, 8 Sep 2020 12:16:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200908100249.23150-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.09.20 12:02, Janosch Frank wrote:
> The storage key removal facility makes skey related instructions
> result in special operation program exceptions. It is based on the
> Keyless Subset Facility.
> 
> The usual suspects are iske, sske, rrbe and their respective
> variants. lpsw(e), pfmf and tprot can also specify a key and essa with
> an ORC of 4 will consult the change bit, hence they all result in
> exceptions.
> 
> Unfortunately storage keys were so essential to the architecture, that
> there is no facility bit that we could deactivate. That's why the
> removal facility (bit 169) was introduced which makes it necessary,
> that, if active, the skey related facilities 10, 14, 66, 145 and 149
> are zero. Managing this requirement and migratability has to be done
> in userspace, as KVM does not check the facilities it receives to be
> able to easily implement userspace emulation.
> 
> Removing storage key support allows us to circumvent complicated
> emulation code and makes huge page support tremendously easier.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> 
> v3:
> 	* Put kss handling into own function
> 	* Removed some unneeded catch statements and converted others to ifs
> 
> v2:
> 	* Removed the likely
> 	* Updated and re-shuffeled the comments which had the wrong information
> 
> ---
>  arch/s390/kvm/intercept.c | 34 +++++++++++++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.c  |  5 +++++
>  arch/s390/kvm/priv.c      | 26 +++++++++++++++++++++++---
>  3 files changed, 61 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index e7a7c499a73f..9c699c3fcf84 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -33,6 +33,7 @@ u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
>  	case ICPT_OPEREXC:
>  	case ICPT_PARTEXEC:
>  	case ICPT_IOINST:
> +	case ICPT_KSS:
>  		/* instruction only stored for these icptcodes */
>  		ilen = insn_length(vcpu->arch.sie_block->ipa >> 8);
>  		/* Use the length of the EXECUTE instruction if necessary */
> @@ -531,6 +532,37 @@ static int handle_pv_notification(struct kvm_vcpu *vcpu)
>  	return handle_instruction(vcpu);
>  }
>  
> +static int handle_kss(struct kvm_vcpu *vcpu)
> +{
> +	if (!test_kvm_facility(vcpu->kvm, 169))
> +		return kvm_s390_skey_check_enable(vcpu);
> +
> +	/*
> +	 * Storage key removal facility emulation.
> +	 *
> +	 * KSS is the same priority as an instruction
> +	 * interception. Hence we need handling here
> +	 * and in the instruction emulation code.
> +	 *
> +	 * KSS is nullifying (no psw forward), SKRF
> +	 * issues suppressing SPECIAL OPS, so we need
> +	 * to forward by hand.
> +	 */
> +	if  (vcpu->arch.sie_block->ipa == 0) {
> +		/*
> +		 * Interception caused by a key in a
> +		 * exception new PSW mask. The guest
> +		 * PSW has already been updated to the
> +		 * non-valid PSW so we only need to
> +		 * inject a PGM.
> +		 */
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +	}
> +
> +	kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
> +	return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
> +}
> +
>  int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>  {
>  	int rc, per_rc = 0;
> @@ -565,7 +597,7 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>  		rc = handle_partial_execution(vcpu);
>  		break;
>  	case ICPT_KSS:
> -		rc = kvm_s390_skey_check_enable(vcpu);
> +		rc = handle_kss(vcpu);
>  		break;
>  	case ICPT_MCHKREQ:
>  	case ICPT_INT_ENABLE:
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6b74b92c1a58..85647f19311d 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2692,6 +2692,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	/* we emulate STHYI in kvm */
>  	set_kvm_facility(kvm->arch.model.fac_mask, 74);
>  	set_kvm_facility(kvm->arch.model.fac_list, 74);
> +	/* we emulate the storage key removal facility only with kss */
> +	if (sclp.has_kss) {
> +		set_kvm_facility(kvm->arch.model.fac_mask, 169);
> +		set_kvm_facility(kvm->arch.model.fac_list, 169);
> +	}
>  	if (MACHINE_HAS_TLB_GUEST) {
>  		set_kvm_facility(kvm->arch.model.fac_mask, 147);
>  		set_kvm_facility(kvm->arch.model.fac_list, 147);
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index cd74989ce0b0..5e3583b8b5e3 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -207,6 +207,13 @@ int kvm_s390_skey_check_enable(struct kvm_vcpu *vcpu)
>  	int rc;
>  
>  	trace_kvm_s390_skey_related_inst(vcpu);
> +
> +	if (test_kvm_facility(vcpu->kvm, 169)) {
> +		rc = kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
> +		if (!rc)
> +			return -EOPNOTSUPP;
> +	}
> +
>  	/* Already enabled? */
>  	if (vcpu->arch.skey_enabled)
>  		return 0;
> @@ -257,7 +264,7 @@ static int handle_iske(struct kvm_vcpu *vcpu)
>  
>  	rc = try_handle_skey(vcpu);
>  	if (rc)
> -		return rc != -EAGAIN ? rc : 0;
> +		return (rc != -EAGAIN || rc != -EOPNOTSUPP) ? rc : 0;

If rc == -EAGAIN you used to return 0.

Now, "-EAGAIN != -EAGAIN || -EAGAIN != -EOPNOTSUPP"

evaluates to "false || true == true"

so you would return rc == -EAGAIN - is that what you really want?

(I've been on vacation for two weeks, my mind might not be fully back :D )

>  
>  	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
>  
> @@ -304,7 +311,7 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
>  
>  	rc = try_handle_skey(vcpu);
>  	if (rc)
> -		return rc != -EAGAIN ? rc : 0;
> +		return (rc != -EAGAIN || rc != -EOPNOTSUPP) ? rc : 0;
>  
>  	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
>  
> @@ -355,7 +362,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
>  
>  	rc = try_handle_skey(vcpu);
>  	if (rc)
> -		return rc != -EAGAIN ? rc : 0;
> +		return (rc != -EAGAIN || rc != -EOPNOTSUPP) ? rc : 0;
>  
>  	if (!test_kvm_facility(vcpu->kvm, 8))
>  		m3 &= ~SSKE_MB;
> @@ -745,6 +752,8 @@ int kvm_s390_handle_lpsw(struct kvm_vcpu *vcpu)
>  		return kvm_s390_inject_prog_cond(vcpu, rc);
>  	if (!(new_psw.mask & PSW32_MASK_BASE))
>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +	if (new_psw.mask & PSW32_MASK_KEY && test_kvm_facility(vcpu->kvm, 169))
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);

You don't use parentheses around & here ...

>  	gpsw->mask = (new_psw.mask & ~PSW32_MASK_BASE) << 32;
>  	gpsw->mask |= new_psw.addr & PSW32_ADDR_AMODE;
>  	gpsw->addr = new_psw.addr & ~PSW32_ADDR_AMODE;
> @@ -771,6 +780,8 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
>  	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
>  	if (rc)
>  		return kvm_s390_inject_prog_cond(vcpu, rc);
> +	if ((new_psw.mask & PSW_MASK_KEY) && test_kvm_facility(vcpu->kvm, 169))
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>  	vcpu->arch.sie_block->gpsw = new_psw;
>  	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> @@ -1025,6 +1036,10 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>  
> +	if (vcpu->run->s.regs.gprs[reg1] & PFMF_SK &&

... and here ...

> +	    test_kvm_facility(vcpu->kvm, 169))
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
> +
>  	if (vcpu->run->s.regs.gprs[reg1] & PFMF_RESERVED)
>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>  
> @@ -1203,6 +1218,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
>  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>  	/* Check for invalid operation request code */
>  	orc = (vcpu->arch.sie_block->ipb & 0xf0000000) >> 28;
> +	if (orc == ESSA_SET_POT_VOLATILE && test_kvm_facility(vcpu->kvm, 169))
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>  	/* ORCs 0-6 are always valid */
>  	if (orc > (test_kvm_facility(vcpu->kvm, 147) ? ESSA_SET_STABLE_NODAT
>  						: ESSA_SET_STABLE_IF_RESIDENT))
> @@ -1451,6 +1468,9 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
>  
>  	kvm_s390_get_base_disp_sse(vcpu, &address1, &address2, &ar, NULL);
>  
> +	if ((address2 & 0xf0) && test_kvm_facility(vcpu->kvm, 169))
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
> +

... but you do here

>  	/* we only handle the Linux memory detection case:
>  	 * access key == 0
>  	 * everything else goes to userspace. */
> 


Do we have to are about vsie? If the g2 CPU does not have storage keys,
also g3 should not. I can spot KSS handling in vsie code - is that
sufficient?

-- 
Thanks,

David / dhildenb

