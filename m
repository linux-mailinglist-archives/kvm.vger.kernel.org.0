Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0921C0925
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfI0QGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:06:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727366AbfI0QGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:06:12 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ECF33C05AA56
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 16:06:11 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id w8so1316902wrm.3
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tlYFE41qduUsi9igPqMAFQ5dqyYqpx0jVUAbChdW/Eo=;
        b=RN6TYnz94dy9DKDo1wPCKmgXzWd4OCoOehbyIda1j1yTUXodllJiVSGPPCJNFRWFkh
         FNotRZlGtuxiwgIj+ySbi8PbOkYF/CE0cJXaXL4sCVIqPPAmruaG0Wy4Q8UBUoV8TrQV
         TTOsj+Fh+q0B2QzUzxo0dK9gPv/Rm3XmKEReSf1DX2pmKr5uZ1bI9Y5jGSxjCPpCsCsK
         pvfEOM1VoqJRpkbDnuN5V5sUPDiWNwskFvhv3Uzdyga+v+QGZiSlA3q0+55NAIs3mz6K
         HZObBr4yPRPHA6cfTqupaYOM6I1y0WEmJ5VEnKbnEBkancrrSfgbbYluHbxuFkmeS1rI
         dpyQ==
X-Gm-Message-State: APjAAAU0fTd0i/Bc785VGQLB6VAvFsX8S7uVPK2r+TbqhBTKcV7l7J1e
        +gxZgvW97sD4VLN3Enb+Zpff7z81BwlAF2YkbprA9yySf33r9XdlGyztrbRskXdgVXAHPME/7hT
        eIxV67MFwqdTB
X-Received: by 2002:a1c:3281:: with SMTP id y123mr7358547wmy.34.1569600370617;
        Fri, 27 Sep 2019 09:06:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwFArU+p/KU2rbV17Ovb/ZTBtvnhY/hp2ypmjzNk5cpIipG3YqAAMHsuxC4y7l1J9dVv8+MFQ==
X-Received: by 2002:a1c:3281:: with SMTP id y123mr7358526wmy.34.1569600370301;
        Fri, 27 Sep 2019 09:06:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id h17sm17822385wme.6.2019.09.27.09.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 09:06:09 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: x86: clarify what is reported on
 KVM_GET_MSRS failure
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20190927155413.31648-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9af23f2e-6f82-e597-abec-ee69c9735faa@redhat.com>
Date:   Fri, 27 Sep 2019 18:06:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927155413.31648-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 17:54, Vitaly Kuznetsov wrote:
> When KVM_GET_MSRS fail the report looks like
> 
> ==== Test Assertion Failure ====
>   lib/x86_64/processor.c:1089: r == nmsrs
>   pid=28775 tid=28775 - Argument list too long
>      1	0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
>      2	0x00000000004010e3: main at state_test.c:171 (discriminator 4)
>      3	0x00007fb8e69223d4: ?? ??:0
>      4	0x0000000000401287: _start at ??:?
>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)
> 
> and it's not obvious that '194' here is the failed MSR index and that
> it's printed in hex. Change that.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index c53dbc6bc568..6698cb741e10 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1085,7 +1085,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
>  	for (i = 0; i < nmsrs; i++)
>  		state->msrs.entries[i].index = list->indices[i];
>  	r = ioctl(vcpu->fd, KVM_GET_MSRS, &state->msrs);
> -        TEST_ASSERT(r == nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed at %x)",
> +        TEST_ASSERT(r == nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed MSR was 0x%x)",
>                  r, r == nmsrs ? -1 : list->indices[r]);
>  
>  	r = ioctl(vcpu->fd, KVM_GET_DEBUGREGS, &state->debugregs);
> 

Queued, thanks.

Paolo
