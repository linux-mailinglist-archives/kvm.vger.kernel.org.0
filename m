Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B57105000
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKUKE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:04:59 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28910 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726165AbfKUKE6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 05:04:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574330698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mlHxf+tx+YK13zm2NVKqdVjZssAdpFxw/aWrK1/1hfg=;
        b=Pw5kTOvI4BBHZExqmiQqcTZphMhna/rpMS/hOW4eOimmmoDGfCMfVSFhepB4Y4sMr4bgTD
        JMh5bK2CV9TQtNRZA8ZScDfHs5JOpHNrpSrQrUY95DDeTygmQQpvsT1zkhL4EBiDZ6Rcfu
        I9A7bM+ElNWPGcr/ZLrpBD2nslF1gpg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-36B-wV4rPYSOsRn07vx1uQ-1; Thu, 21 Nov 2019 05:04:54 -0500
Received: by mail-wr1-f71.google.com with SMTP id y3so1781598wrm.12
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:04:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=14cqlJbT4+OSkrklIS+IpnOGoM9sdQwDr0naWLYs+xA=;
        b=ffMUGnJJ/YjYy5PRgSmsQNvAPKnpBLlzY5dX8ofqpPbQpEe47fnX42BHDfOuqIw4/U
         g+fZH/QAqFgIsiUTwCy1Knl5uEMvuZflMEXnZOo0y4A1DE/35HLeEWl72wt5wu0dBeA7
         TVOB3D3DcQk5u5VbU8hviuvTqcNTVhSOVDhnth+rff4XxicjEItxaOwZVa/D10fohEDd
         32nDvh1kOMBcU7TCiQX4Q6/h8rqMhsscdQuaQUZTcCcxVpakYHeZharyEIW0lxNrJa4x
         DJiWYOr35farKzmCf04KGTZG4CQK9Gq4m3S6yeWjU5aR1JG9cQTBSHAOnKlgvp8HPsGo
         bPEA==
X-Gm-Message-State: APjAAAUktcOdiurCCOOF3mehUzTlLUh+LOBv36TL/58Ous9KzvArDGyO
        pGL71jg5djUPVPDz84WaO9vib7WxSeiIF3ugklG1c7cmTAvPMUwuLiYKQPchs5ymcDwLOkpkJ3j
        LR0CNS8M3mmcH
X-Received: by 2002:adf:f987:: with SMTP id f7mr9459668wrr.284.1574330693358;
        Thu, 21 Nov 2019 02:04:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqzUISdg7RN9omhcEa8sb+8q2vJs6Xcjtp9Kl1BiFvArAIiyHPbyqyJaaaxsnVetKraFLYN3FA==
X-Received: by 2002:adf:f987:: with SMTP id f7mr9459632wrr.284.1574330693096;
        Thu, 21 Nov 2019 02:04:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id j67sm2428269wmb.43.2019.11.21.02.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:04:52 -0800 (PST)
Subject: Re: [PATCH v7 2/9] vmx: spp: Add control flags for Sub-Page
 Protection(SPP)
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-3-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d6e71e7b-b708-211c-24b7-8ffe03a52842@redhat.com>
Date:   Thu, 21 Nov 2019 11:04:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-3-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: 36B-wV4rPYSOsRn07vx1uQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> @@ -228,6 +228,7 @@
>  #define X86_FEATURE_FLEXPRIORITY=09( 8*32+ 2) /* Intel FlexPriority */
>  #define X86_FEATURE_EPT=09=09=09( 8*32+ 3) /* Intel Extended Page Table =
*/
>  #define X86_FEATURE_VPID=09=09( 8*32+ 4) /* Intel Virtual Processor ID *=
/
> +#define X86_FEATURE_SPP=09=09=09( 8*32+ 5) /* Intel EPT-based Sub-Page W=
rite Protection */

Please do not include X86_FEATURE_SPP.  In general I don't like the VMX
features word, but apart from that SPP is not a feature that affects all
VMs in the same way as EPT or FlexPriority.

Paolo

