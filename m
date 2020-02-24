Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29ED16AFF3
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 20:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgBXTGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 14:06:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45648 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726673AbgBXTGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 14:06:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582571192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ce5lU2sN8kthzisNOTMin3VlfueRzP4XPZzRMH5N1JE=;
        b=ir3LQaPoQAk3hHGXLLa2sKfWqqZ4SsbiDvaH020YtvEhp5ruu6HWi3Tmbfy9pkXVmTtErn
        n0DFJCo6dnE2KoQXYFRCiMTPcp0RrI0MR8kJMDXorCWQfXWX74N6+dm0fpkBXpjDrG3NqN
        uKEe6u3qya/ow0YzzFh0H3ZUML9yEgA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-BFb_inMNMQO1p1HCXr_bmg-1; Mon, 24 Feb 2020 14:06:18 -0500
X-MC-Unique: BFb_inMNMQO1p1HCXr_bmg-1
Received: by mail-wm1-f70.google.com with SMTP id p2so134416wmi.8
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 11:06:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ce5lU2sN8kthzisNOTMin3VlfueRzP4XPZzRMH5N1JE=;
        b=JeKgOs+hwv4//r7AVPmSrWb2HKYSjTVTyfannX5g8zXjVnxAZnDef3VYAPIWzatNBE
         GfUsaKyVh87RbiOcoW5kOxSSZi5ZaWNKRzeFKkGyATOu/1ldbsWOJso2X8XcHYzzdaHF
         g26BV+y5fHAIGDPG92CTLJkTy+z64Lzy5d3UgtlGLPM+LKQDONwctQfo0CXS4RIGMsjm
         jOU089QMwXuaLpRd5Nklgu+HjOUKMEXAUgYR0Hf1MOD/igsHRkp+V2F+vuO/hqfVnY5U
         iWR0SyZ9DONXxwkvnoJo1wxbRRhGCQ8hI4s1X5ZSZhCkgiw/Ah7GYUz8L9mXVT27F3Qv
         e1ww==
X-Gm-Message-State: APjAAAWS1U8NxkdTkf3M2VCKoU45VPzJyNMeizTmAT/HU49BwGm+MXSK
        p3I4IYkZnaIu9SGFCkDC3ev+VoIF4Pryp32AUvIilWO2gMsCXdQFovsqLHKtEK9Z8By3vIzmN3L
        6LNjeu06PLYK5
X-Received: by 2002:a5d:628e:: with SMTP id k14mr5697441wru.425.1582571176892;
        Mon, 24 Feb 2020 11:06:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqzblSbDkgRnpJ8Okfn3VAzS7qE9rfZ8qpYd4f16XCyFdWFoACROhrJmfam+iky3Ka/8PqROCg==
X-Received: by 2002:a5d:628e:: with SMTP id k14mr5697418wru.425.1582571176511;
        Mon, 24 Feb 2020 11:06:16 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:60c6:7e02:8eeb:a041? ([2001:b07:6468:f312:60c6:7e02:8eeb:a041])
        by smtp.gmail.com with ESMTPSA id x6sm441205wmi.44.2020.02.24.11.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 11:06:15 -0800 (PST)
Subject: Re: [PATCH] KVM: selftests: Fix unknown ucall command asserts
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
References: <20200224161049.18545-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f9923a55-5372-d739-ee29-967b06a0546d@redhat.com>
Date:   Mon, 24 Feb 2020 20:06:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224161049.18545-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/20 17:10, Andrew Jones wrote:
> The TEST_ASSERT in x86_64/platform_info_test.c would have print 'ucall'
> instead of 'uc.cmd'. Also fix all uc.cmd format types.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c       | 2 +-
>  tools/testing/selftests/kvm/x86_64/evmcs_test.c                | 2 +-
>  tools/testing/selftests/kvm/x86_64/platform_info_test.c        | 3 +--
>  tools/testing/selftests/kvm/x86_64/state_test.c                | 2 +-
>  .../testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c | 2 +-
>  tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c        | 2 +-
>  tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c       | 2 +-
>  7 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
> index 63cc9c3f5ab6..003d1422705a 100644
> --- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
> @@ -106,7 +106,7 @@ int main(int argc, char *argv[])
>  		case UCALL_DONE:
>  			goto done;
>  		default:
> -			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
> +			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
>  		}
>  	}
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> index 92915e6408e7..185226c39c03 100644
> --- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> @@ -117,7 +117,7 @@ int main(int argc, char *argv[])
>  		case UCALL_DONE:
>  			goto done;
>  		default:
> -			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
> +			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
>  		}
>  
>  		/* UCALL_SYNC is handled here.  */
> diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> index f9334bd3cce9..54a960ff63aa 100644
> --- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> @@ -58,8 +58,7 @@ static void test_msr_platform_info_enabled(struct kvm_vm *vm)
>  			exit_reason_str(run->exit_reason));
>  	get_ucall(vm, VCPU_ID, &uc);
>  	TEST_ASSERT(uc.cmd == UCALL_SYNC,
> -			"Received ucall other than UCALL_SYNC: %u\n",
> -			ucall);
> +			"Received ucall other than UCALL_SYNC: %lu\n", uc.cmd);
>  	TEST_ASSERT((uc.args[1] & MSR_PLATFORM_INFO_MAX_TURBO_RATIO) ==
>  		MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
>  		"Expected MSR_PLATFORM_INFO to have max turbo ratio mask: %i.",
> diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
> index 9d2daffd6110..164774206170 100644
> --- a/tools/testing/selftests/kvm/x86_64/state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/state_test.c
> @@ -160,7 +160,7 @@ int main(int argc, char *argv[])
>  		case UCALL_DONE:
>  			goto done;
>  		default:
> -			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
> +			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
>  		}
>  
>  		/* UCALL_SYNC is handled here.  */
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
> index 5dfb53546a26..cc17a3d67e1f 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
> @@ -81,7 +81,7 @@ int main(int argc, char *argv[])
>  			TEST_ASSERT(false, "%s", (const char *)uc.args[0]);
>  			/* NOT REACHED */
>  		default:
> -			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
> +			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
>  		}
>  	}
>  }
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> index a223a6401258..fe0734d9ef75 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> @@ -152,7 +152,7 @@ int main(int argc, char *argv[])
>  			done = true;
>  			break;
>  		default:
> -			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
> +			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
>  		}
>  	}
>  }
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
> index 64f7cb81f28d..5f46ffeedbf0 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
> @@ -158,7 +158,7 @@ int main(int argc, char *argv[])
>  		case UCALL_DONE:
>  			goto done;
>  		default:
> -			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
> +			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
>  		}
>  	}
>  
> 

Queued, thanks.

Paolo

