Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC3C4650E1
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350557AbhLAPJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350460AbhLAPJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:09:03 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C6CC061756;
        Wed,  1 Dec 2021 07:05:42 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z5so37914529edd.3;
        Wed, 01 Dec 2021 07:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MBT3RPen2M431MDKHFSMebGnut1XmD83aF6y4bnLBoE=;
        b=aUUpW0y4Fl3KE6dPk2xZJLBZlss1B9u+yDHnRR+V+DiVzP7w03taRDeCXSZlk9Vilp
         FpEoMBLzSC6g2YL/MlRPq1Fl40yqyW2DvFgH/y4wZaLUlgKGDiYG9H+ek45btPGd7a2R
         pzVl1kZ3L+eJpAi3tw8+Kh2RO46Vg5RPZSYa/jXH3su9CjghT6puhs3LIbgCgiplZ7Mm
         v47ko61h83oS2nx5bgYeJD5rXcCPwDDkREzQOl34lD/O8BA2Ej7bOowKW+orCt0wlt6M
         VlQrugZLDi+ypK9xWxJLoY+tCLb/nu96rLuvIkVzNAyyEKBZFZ3pHBczVf9pKwTPcAk4
         1jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MBT3RPen2M431MDKHFSMebGnut1XmD83aF6y4bnLBoE=;
        b=lUyYkkR46FGQXcxogh8lOgRMt+HR3BCbsvq1cfxUws/RM5QW/OQCvkfTgAWX/332Fo
         IEGNZDJHfo8Srvv/3x4cOIrHUrhHhtdTErEwK0p7CW/Mq5SXOLzjzUFUHM7oWuJc72zz
         riH+HC7bM+vAIFkX1TMdm2gY9ov0uFExnnrRChvmpBsnVwt88T2MshtZ0JdyDa2J4nXe
         VglX94GIkiiqXu3K3KNKl6eNfoOTW8IyjMuMwj+I92Y/ZP56Q6l/eMAHdOpN8o2hIoxo
         g8Ic3UzFq/W3GDQT+NIvtE9wEx2ibryvmuyZ5nMs85n5IR6jmah/uOSSTThxGC+Vf1KI
         hLUw==
X-Gm-Message-State: AOAM531BtAvWCKQE3Ym8bpxttZdASB1/BMtOCkBI+tHBZgR20WH1D59P
        TH/uSceGzSj1GXvfzOsstRI=
X-Google-Smtp-Source: ABdhPJxm4ZE4RV4M+RYm5RijIK5XPgqp/L+Smx4PqR/1o80Gf/aQZXxqwcMbNofC/qZjfZ4MccFfvQ==
X-Received: by 2002:a17:907:764b:: with SMTP id kj11mr7550132ejc.307.1638371139141;
        Wed, 01 Dec 2021 07:05:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id og38sm24863ejc.5.2021.12.01.07.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 07:05:38 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bb6dd4eb-c713-f0e5-71fa-b0a514c4da6c@redhat.com>
Date:   Wed, 1 Dec 2021 16:05:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 00/59] KVM: X86: TDX support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <YaZyyNMY80uVi5YA@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaZyyNMY80uVi5YA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 19:51, Sean Christopherson wrote:
> On Wed, Nov 24, 2021,isaku.yamahata@intel.com  wrote:
>> - drop load/initialization of TDX module
> So what's the plan for loading and initializing TDX modules?
> 

The latest news I got are that Intel has an EFI application that loads 
it, so loading it from Linux and updating it at runtime can be punted to 
later.

Paolo
