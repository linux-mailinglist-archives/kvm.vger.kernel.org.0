Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA6A42D853
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 13:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhJNLlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 07:41:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230473AbhJNLli (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 07:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634211573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zUt09S4csvlYuawOC+3Rd0m1qDOaKGhw9lW/9LXEe7k=;
        b=Dcigtc7iDHs0LTJbwI6ykop9wCyRSgRhmuvaCaacFji5MJcErtJX6prhZFskOJKDtRRTSb
        a6MMnFCDvQJS6sOzLuzozTZ/BYZfsc0oxFwl89cHGOwDrlo++hCrlUjFZesBnspEvkLacR
        XNY6/UzDgdqAekW2Fvu5ZLgDVWwKWS0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-ZQ2TrzsUOmeOqOsUHQB2_A-1; Thu, 14 Oct 2021 07:39:32 -0400
X-MC-Unique: ZQ2TrzsUOmeOqOsUHQB2_A-1
Received: by mail-ed1-f72.google.com with SMTP id g28-20020a50d0dc000000b003dae69dfe3aso4915647edf.7
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 04:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zUt09S4csvlYuawOC+3Rd0m1qDOaKGhw9lW/9LXEe7k=;
        b=U+IKzK7KvF7XUmTih3AeGWQ2yXxiV6bP1nwOHeggRl+GMk4mm7tmk2TxQTOzvyfWLD
         EXdNhUWz8ennPUcw4dLihUvswtZbfGedWbpw02ZkcpBrUN5JnG2FaN0u2udzz4eYzq+z
         TKUtzRghamEQLJ6+twuqSHcOHPXtOppxKgJ4Fdpqt0RbiMJbMOR8X/LutriI68c5CrR/
         NjvD4/6wXKn9WgTfdvXWmC9NTXGDzKL+CxPQkqf5ycG7WWVhXqM8jVeXw3gutUUCRAwS
         EMxXtJhQOMrR+fGipUIVM4K3Y2alU+LXqrCkTt3NsQpDGXcZh5PWvco71AohN8qzP5J5
         colA==
X-Gm-Message-State: AOAM530LXGjgd2UVo8NcxPl24EM4AKe2TEjdu2244EGYLT4kCIxk+7VP
        0mCUE7e5Q7EIw8MSDWG75xboOQXgWdZMo3FqYexdy8g8uFM2RuCNwqxDmsZqCe4PJBz41uFIygY
        L68UKqNlcrRma
X-Received: by 2002:a17:906:5f8e:: with SMTP id a14mr3187485eju.155.1634211571567;
        Thu, 14 Oct 2021 04:39:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyShlU79JrsHL4kA6p6xoWiNJO7pml0YFLFUDMjqsmGyUAf3uRy/R8wnMS4pDLr590B/MN1eg==
X-Received: by 2002:a17:906:5f8e:: with SMTP id a14mr3187458eju.155.1634211571367;
        Thu, 14 Oct 2021 04:39:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o12sm1986907edw.84.2021.10.14.04.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 04:39:30 -0700 (PDT)
Message-ID: <9c2e202b-4e15-2728-4c61-a2f74adac444@redhat.com>
Date:   Thu, 14 Oct 2021 13:39:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Language: en-US
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
 <BYAPR11MB32565A69998A2D3C26054D3EA9B89@BYAPR11MB3256.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BYAPR11MB32565A69998A2D3C26054D3EA9B89@BYAPR11MB3256.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/21 13:30, Liu, Jing2 wrote:
> I guess we're worrying about is when KVM is sched_out, a nonzero XFD_ERR
> can be lost by other host thread. We can save guest XFD_ERR in sched_out
> and restore before next vmenter. Kernel is assumed not using AMX thus
> softirq won't make it lost.
> I think this solves the problem. So we can directly passthrough RW of it,
> and no need to rdmsr(XFD_ERR) in vmexit.

Correct; you can also use the "user-return MSRs" machinery (until Linux 
starts using AMX in the kernel, but that shouldn't happen too soon).

Paolo

