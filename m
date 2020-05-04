Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10E11C3F18
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgEDPzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:55:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728294AbgEDPzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 11:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588607714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zcu06Px3HfWIzeps5g66nRNvti217ZmUAEgFVFyuGCQ=;
        b=hiqcwTyopXgGVqCE79c/9xusBokK341aHYe4EnQW9PlyiWBRzIrihXabNajcMpNXl8AbCh
        adLE/PJAOkT9dAYwVKaQU1r1WHAd+dHazzc1hw03nigl+oX8Cdeji5jZ3RvEgZGW3u+Nz9
        wbt1c7p0eMlq2nfI67/xd0ZYwMhNNc8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-g4r627XgNGS5-KVOO4LxnA-1; Mon, 04 May 2020 11:55:13 -0400
X-MC-Unique: g4r627XgNGS5-KVOO4LxnA-1
Received: by mail-wr1-f71.google.com with SMTP id o8so10958425wrm.11
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 08:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zcu06Px3HfWIzeps5g66nRNvti217ZmUAEgFVFyuGCQ=;
        b=D24dZJ9R/Jqt6nj/kNRNReM/M1xAxrp8tiV6UtbYt1dJ3CGYhncw8A3FXo20JCbQ4C
         wh0ldGUK8TnlQedyyGl0CLO5+D0kT3XCjw2PZqSmfZtWTmv423IosPLC9AnCEUCpyJ1w
         gK1REk5Z6313q4Hxsdf+G5+IzZ49CASQ9UCpG6YnoS4+GioHT0+GUNPGuUJjS/nlQfSe
         kcR47t55AALZCglcO+k5X1qNC6mgOL2t78yra8ogaAbGarEzVTeHWFSVZU45FPmAsqbz
         uqjezB4J0QotliriyChiWkTjoOCyzPn3cbP8wqECaafLxZud3UWa+OTKJcq7QjU6Gqgf
         SSyw==
X-Gm-Message-State: AGi0PubYQiQXVhnFqUKOVxScpSu/ampoUgy9W8l76erP6YdkC4eUK3MC
        wTGNkotarDJw4mW7JP+A5aJJCM+HoYqC5LaavJhsk2boEtW4YDpx5nml+NvUaNA8rCUR6J6DMaF
        1f1yerm/i2vEd
X-Received: by 2002:adf:d0ca:: with SMTP id z10mr21780674wrh.172.1588607712233;
        Mon, 04 May 2020 08:55:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypLcbfKJHM1xBofC7P6FXO16OQiRP6dTUfxovFqqJdlElXN6GtF6sHXmbN0bGbmqvjjgTH7sEw==
X-Received: by 2002:adf:d0ca:: with SMTP id z10mr21780655wrh.172.1588607712026;
        Mon, 04 May 2020 08:55:12 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u2sm17535810wrd.40.2020.05.04.08.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 08:55:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>, Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
In-Reply-To: <20200503191900.GA389956@rvkaganb>
References: <20200416083847.1776387-1-arilou@gmail.com> <20200416120040.GA3745197@rvkaganb> <20200416125430.GL7606@jondnuc> <20200417104251.GA3009@rvkaganb> <20200418064127.GB1917435@jondnuc> <20200424133742.GA2439920@rvkaganb> <20200425061637.GF1917435@jondnuc> <20200503191900.GA389956@rvkaganb>
Date:   Mon, 04 May 2020 17:55:10 +0200
Message-ID: <87a72nelup.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Roman Kagan <rvkagan@yandex-team.ru> writes:

> On Sat, Apr 25, 2020 at 09:16:37AM +0300, Jon Doron wrote:
>
>> If that's indeed the case then probably the only thing needs fixing in my
>> scenario is in QEMU where it should not really care for the SCONTROL if it's
>> enabled or not.
>
> Right.  However, even this shouldn't be necessary as SeaBIOS from that
> branch would enable SCONTROL and leave it that way when passing the
> control over to the bootloader, so, unless something explicitly clears
> SCONTROL, it should remain set thereafter.  I'd rather try going ahead
> with that scheme first, because making QEMU ignore SCONTROL appears to
> violate the spec.

FWIW, I just checked 'genuine' Hyper-V 2016 with

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index fd51bac11b46..c5ea759728d9 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -314,10 +314,14 @@ void __init hyperv_init(void)
        u64 guest_id, required_msrs;
        union hv_x64_msr_hypercall_contents hypercall_msr;
        int cpuhp, i;
+       u64 val;
 
        if (x86_hyper_type != X86_HYPER_MS_HYPERV)
                return;
 
+       hv_get_synic_state(val);
+       printk("Hyper-V: SCONTROL state: %llx\n", val);
+
        /* Absolutely required MSRs */
        required_msrs = HV_X64_MSR_HYPERCALL_AVAILABLE |
                HV_X64_MSR_VP_INDEX_AVAILABLE;


and it seems the default state of HV_X64_MSR_SCONTROL is '1', we should
probably do the same. Is there any reason to *not* do this in KVM when
KVM_CAP_HYPERV_SYNIC[,2] is enabled?

-- 
Vitaly

