Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F72B1F1911
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgFHMrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:47:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20771 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728876AbgFHMrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 08:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6GGnXZ/Ulj1bARnVGb1xIL6hYlj/UOXcAA/U4xgpTfA=;
        b=SUgOlxWXWc7IV2YH/puZ97cZXDvWp8Z9msRRoMvR97atc6WaYnkfzFJ4/U2MgesYhNA6Ti
        KWfmBdmUQCLsaeuR0pFVggbzfa1jispUS7QChjbtLZEFMZIwoQUj+3hEMFiXumOuz+Eaej
        sDDs6IkW6Put3YqKM3+68eSfviYgKZM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-VPelCohaNF6m6rrqVDStCg-1; Mon, 08 Jun 2020 08:47:40 -0400
X-MC-Unique: VPelCohaNF6m6rrqVDStCg-1
Received: by mail-wr1-f69.google.com with SMTP id s17so7074717wrt.7
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 05:47:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6GGnXZ/Ulj1bARnVGb1xIL6hYlj/UOXcAA/U4xgpTfA=;
        b=jpWWqnAf5zsy4+3Bb2ohUVeaVLDXxYPBWTjXwYxn/gO0wgAPGYFDyIbY4PNfmdAvan
         lxjQpmsXUoLOaIIbL+cKABx8BJKZua7QqIf/OEqlq+UpnXIGL09OhaZ+OBMojLEo/oMr
         znDREvuX8XdhNKi2cKcP3gqgtoOM+AC5hhArNjvZHv3CFYMmJvpHASaMetWeTxkNkAcn
         QWZpwzbjJjlMmN2Q1RhTktrmFU8XyhAcoJd00xTeZOF8p823JRB7qAlVHmXRen3B+D/e
         FKrKhrWk9YUToufIqCPNu9O0xOe2plBSnlyV2QkSPlXbBoNJtDGdRE6VAmDVhy2voxRc
         /sRQ==
X-Gm-Message-State: AOAM5305WQug8ZsQagTCL6e6WD3owl5DrkcbwP4+pXSDfURRTRbYEty7
        IfXXS49FUTvWAY88kUuwI9LHt6y2UeCdKi61oPw/TK3WptD17qUXouEWYYTZde44E7n9a2qqZDx
        4j/2e6tHc86b3
X-Received: by 2002:adf:fb92:: with SMTP id a18mr23839341wrr.263.1591620458917;
        Mon, 08 Jun 2020 05:47:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEObCByEdnj3+VFYbS8XRYICS/8MHOag4jzq+lGs+CLQhZQYwnAKbGx+cjPlETlJKPhRESfw==
X-Received: by 2002:adf:fb92:: with SMTP id a18mr23839319wrr.263.1591620458634;
        Mon, 08 Jun 2020 05:47:38 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.87.23])
        by smtp.gmail.com with ESMTPSA id a1sm21965353wmj.29.2020.06.08.05.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 05:47:38 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 2/2] svm: INIT intercept test
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200608122800.6315-1-cavery@redhat.com>
 <20200608122800.6315-3-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4230c304-f08b-694b-9a8e-8f5b32eeb4e8@redhat.com>
Date:   Mon, 8 Jun 2020 14:47:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200608122800.6315-3-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/20 14:28, Cathy Avery wrote:
> INIT vcpu 2 and intercept the INIT. This test
> will leave the vcpu in an unusable state.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>

It should be possible to reinitialize the vCPU using a SIPI interrupt, like

	old = cpu_online_count--;
	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DEST_SIPI,
		       id_map[cpu]);
	while (cpu_online_count != old)
		cpu_relax();

You can test this by using vCPU 1 to run this test.

Paolo

> ---
>  x86/svm_tests.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index c1abd55..a4dbe91 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1789,6 +1789,43 @@ static bool virq_inject_check(struct svm_test *test)
>      return get_test_stage(test) == 5;
>  }
>  
> +static volatile bool init_intercept;
> +
> +static void init_signal_intercept_prepare(struct svm_test *test)
> +{
> +
> +    vmcb_ident(vmcb);
> +    vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
> +    init_intercept = false;
> +}
> +
> +static void init_signal_test(struct svm_test *test)
> +{
> +    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
> +}
> +
> +static bool init_signal_finished(struct svm_test *test)
> +{
> +    vmcb->save.rip += 3;
> +
> +    if (vmcb->control.exit_code != SVM_EXIT_INIT) {
> +        report(false, "VMEXIT not due to init intercept. Exit reason 0x%x",
> +               vmcb->control.exit_code);
> +        return true;
> +        }
> +
> +    init_intercept = true;
> +
> +    report(true, "INIT to vcpu intercepted");
> +
> +    return true;
> +}
> +
> +static bool init_signal_check(struct svm_test *test)
> +{
> +    return init_intercept;
> +}
> +
>  #define TEST(name) { #name, .v2 = name }
>  
>  /*
> @@ -1950,6 +1987,9 @@ struct svm_test svm_tests[] = {
>      { "virq_inject", default_supported, virq_inject_prepare,
>        default_prepare_gif_clear, virq_inject_test,
>        virq_inject_finished, virq_inject_check },
> +    { "svm_init_signal_intercept_test", default_supported, init_signal_intercept_prepare,
> +      default_prepare_gif_clear, init_signal_test,
> +      init_signal_finished, init_signal_check, .on_vcpu = 2 },
>      TEST(svm_guest_state_test),
>      { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
> 

