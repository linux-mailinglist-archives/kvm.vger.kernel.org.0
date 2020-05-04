Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDEC1C3FFB
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgEDQeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:34:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37672 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729697AbgEDQeY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 12:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588610063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=meXN8fnH7POJ5nXM4MsgSydS0mBB1vuDTCk9COvduPs=;
        b=TNBTURtdj3BUz81YYBVrJy1JEpCNYb8zFLTVXdLzAKLSiD5cBGcrfz8BG7kbJ+h3IQkB23
        tX40qX9vZV0NSWl7AfbhfUQbnftTqrRAn0pORJDV2vs07a6gkdWWsLviPfHXijTC5dO52+
        FFkVSAvsS6A7CP3siRVMiUUooR787n4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-jlev1s-LNBS0H2zJ9XLCSQ-1; Mon, 04 May 2020 12:34:21 -0400
X-MC-Unique: jlev1s-LNBS0H2zJ9XLCSQ-1
Received: by mail-wm1-f70.google.com with SMTP id j5so78476wmi.4
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=meXN8fnH7POJ5nXM4MsgSydS0mBB1vuDTCk9COvduPs=;
        b=m6OuqdV0qricSDNhbrJ4fzNn1l5Apfz7I5R2GcU+1didXCoCJtpcjll18wJ3S5K8Or
         itzRO2ZLO4g8H/4H86V+TwfrScEC1tQo6QBlB8rgQONMvqdMAlHjqoIEk0SxgyA9WglM
         UPKseOMXoO/i6f2ikDYKaivXopT8RBu/ia+Bmz63C3mJ2/eGYy1BPniGhhsWnVpGQp8M
         TAlvZTXiCT7mP5Q6gq5qISKuHKajcw34dDlFgG+2YNsJl5vfZWMZNf7j0YyW8nr2OXE7
         j7vlplbP5KWPpb9/+nNjYnus2tibWYN5SsLgLVWaZ9mM7PT/X8nBjlSGZb3ZpRNFeLlE
         fVpQ==
X-Gm-Message-State: AGi0PuYlNNuK6/2Ji4NDEBVu5j2S/rR4VUDQryWFUgoaY5EvBLsNl7Jh
        YIB164U0w/60nBRAU/i4CbDC5zpcoVI2BSCLfzaUdXkZc0ZKonz//NZBbCZpoPGZDvpGOrL7L9u
        cOyoTRzpLagTB
X-Received: by 2002:a5d:4fc6:: with SMTP id h6mr21468723wrw.277.1588610060492;
        Mon, 04 May 2020 09:34:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypIbJp70n46iTVVSbiakPJEd161uPQFwM/5IMglu/dwNQXKrQl5PLIS1MiU2eQPm3GMoD+dnjg==
X-Received: by 2002:a5d:4fc6:: with SMTP id h6mr21468705wrw.277.1588610060224;
        Mon, 04 May 2020 09:34:20 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id m15sm14162083wmc.35.2020.05.04.09.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:34:19 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] nVMX: Check EXIT_QUALIFICATION on VM-Enter
 failures due to bad guest state
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200424174025.1379-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0fd2d12-ca9a-9516-1d4c-e375bbf7bceb@redhat.com>
Date:   Mon, 4 May 2020 18:34:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200424174025.1379-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/20 19:40, Sean Christopherson wrote:
> Assert that vmcs.EXIT_QUALIFICATION contains the correct failure code on
> failed VM-Enter due to invalid guest state.  Hardcode the expected code
> to the default code, '0', rather than passing in the expected code to
> minimize churn and boilerplate code, which works for all existing tests.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/vmx.h       | 7 +++++++
>  x86/vmx_tests.c | 3 ++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 2e28ecb..08b354d 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -521,6 +521,13 @@ enum vm_instruction_error_number {
>  	VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID = 28,
>  };
>  
> +enum vm_entry_failure_code {
> +	ENTRY_FAIL_DEFAULT		= 0,
> +	ENTRY_FAIL_PDPTE		= 2,
> +	ENTRY_FAIL_NMI			= 3,
> +	ENTRY_FAIL_VMCS_LINK_PTR	= 4,
> +};
> +
>  #define SAVE_GPR				\
>  	"xchg %rax, regs\n\t"			\
>  	"xchg %rcx, regs+0x8\n\t"		\
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4a3c56b..f5a646f 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5255,7 +5255,8 @@ static void test_guest_state(const char *test, bool xfail, u64 field,
>  
>  	report(result.exit_reason.failed_vmentry == xfail &&
>  	       ((xfail && result.exit_reason.basic == VMX_FAIL_STATE) ||
> -	        (!xfail && result.exit_reason.basic == VMX_VMCALL)),
> +	        (!xfail && result.exit_reason.basic == VMX_VMCALL)) &&
> +		(!xfail || vmcs_read(EXI_QUALIFICATION) == ENTRY_FAIL_DEFAULT),
>  	        "%s, %s %lx", test, field_name, field);
>  
>  	if (!result.exit_reason.failed_vmentry)
> 

Queued, thanks.

Paolo

