Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B8C21661E
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 08:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgGGGCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 02:02:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33524 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727876AbgGGGCs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 02:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594101766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msc0YVCqbe/zeeKFjSXjbyw1u5ayac1sxNjQyaDDims=;
        b=Hb5sN22PrBjOOsqeD77wZxSy6FbAkZB22wmiqCstPXvMP1MdgPqvjo4c3OWyLz3QnVc+KW
        Y8LRAuSrpSwx246xeo7LhJt1vJeNdbjhDkDZsHQTAxvtKKxJymUo01t4Y1h4UPpWdxnFXo
        yvYdN9u7JLbfrW/Nk4iK0ZTMKLpEUns=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-mfydYwlnPAmN6k0dQ2Q6VA-1; Tue, 07 Jul 2020 02:02:44 -0400
X-MC-Unique: mfydYwlnPAmN6k0dQ2Q6VA-1
Received: by mail-wr1-f71.google.com with SMTP id b14so47707189wrp.0
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 23:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=msc0YVCqbe/zeeKFjSXjbyw1u5ayac1sxNjQyaDDims=;
        b=WdkgImHfddfkbmk7jK+HK32fZjRPhECV8lD/YvD9ORXG+rlcvYkIEizV+NSBTFrF8U
         o8IGNCV0ZWLKozVIXJWPPHTYz+sUZwXd3IvTkgsLxzdTu2PHkJ8gpWhMoKK0UdIAITIB
         gIPgmvgYTfxzyd6IPKu3rMiOjjy1bg0JnD0FgWYXZNB/SMUnLF0v/JIoCyCpLroRm2KH
         BPBcRSdi6RCIpsv26t7XF+4RSy4C5doCthI5r8QyC3Ut9ya1l0RAxQW2w3VqAuXDqFVi
         fyY6ZZSMMAhM614MDApqyLfh6qWCMk06Pp9d1lhiW/sVtmKGlJ1CtFByYxBecpIDMt/P
         9U4g==
X-Gm-Message-State: AOAM533GtWa+42wK13tDHIH9pK4TIvVcz+UCAU8B5REYwUep5+K9r3My
        FE0ScRMhHb3EkY9db+HoXd55k8tPWqU3BzuSNCRnNn5f2ikAj0uiuE2UsUWbwuFMb/9QM0fivUI
        9JwNkszIQJnhx
X-Received: by 2002:a7b:c5c1:: with SMTP id n1mr2508441wmk.21.1594101762821;
        Mon, 06 Jul 2020 23:02:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzC1lQ5qbmBqJ3qbsM4HjJ4H2sCV9QcVWDzcuI/cOeg8p1XwZWGJ36wUrex8CYNfdEt2ifyHw==
X-Received: by 2002:a7b:c5c1:: with SMTP id n1mr2508420wmk.21.1594101762595;
        Mon, 06 Jul 2020 23:02:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e95f:9718:ec18:4c46? ([2001:b07:6468:f312:e95f:9718:ec18:4c46])
        by smtp.gmail.com with ESMTPSA id n17sm25960938wrs.2.2020.07.06.23.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 23:02:42 -0700 (PDT)
Subject: Re: Question regarding nested_svm_inject_npf_exit()
To:     Jim Mattson <jmattson@google.com>,
        Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>
References: <DAFEA995-CFBA-4466-989B-D63466815AB1@gmail.com>
 <f297ebf8-15b8-57d3-4c56-fdf3f5d16b9d@redhat.com>
 <2B43FBC4-D265-4005-8FBA-870BDC627231@gmail.com>
 <CALMp9eTDCDNctpso23uv+gM0QZUEBzMw47-M9JfNaG79fusa2A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <773a4e20-3dd3-972c-8671-222672e54825@redhat.com>
Date:   Tue, 7 Jul 2020 08:02:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTDCDNctpso23uv+gM0QZUEBzMw47-M9JfNaG79fusa2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/20 01:26, Jim Mattson wrote:
>> Well, I think we can agree that bare-metal is a better reference than
>> another emulator for the matter. Even without running the tests on
>> bare-metal, it is easy to dump EXITINFO1 on the nested page-fault. I will
>> try to find a bare-metal machine.
>>
>> Anyhow, I would appreciate if anyone from AMD would tell whether any result
>> should be considered architectural.
> 
> I'd be happy to test on bare metal, but I'm still waiting for
> instructions that a script kiddie (with read-only console access) can
> follow.

I'll try to test myself and prepare some instructions.

Paolo

