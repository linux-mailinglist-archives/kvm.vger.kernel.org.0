Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E307D129916
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 18:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLWRJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 12:09:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726754AbfLWRJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 12:09:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577120969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EdGWVlIuDUVd73iaM6l6M5W4eKbIMhKZ4IFEX++PL4k=;
        b=UA+BSTD0TzsU7QYf4aB6xvOabZXcfB341HQZb2ds6z+UY0R2424TUdqbCsKLEKQwU6JcaR
        wIUJ1R0aRfQXLy4KORwJ/FgS01o90t/E7qFZzGSoegEoat3MLBgf8E/6sMa3WV1ux+dsIW
        jTLnbuQFOfLSIq+zJggvEpRwfsBrUc8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-xaUwiQ1GPYWyN-i_mr4q_g-1; Mon, 23 Dec 2019 12:09:27 -0500
X-MC-Unique: xaUwiQ1GPYWyN-i_mr4q_g-1
Received: by mail-wr1-f69.google.com with SMTP id c17so2132503wrp.10
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2019 09:09:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EdGWVlIuDUVd73iaM6l6M5W4eKbIMhKZ4IFEX++PL4k=;
        b=YcYOYV3asFMfGfj///rJiw/sThD+VcHhHPZ1aPe48H1IJ+Dgb8qQgo1Jtr2W7Fe4Gi
         KpQBeRAnTM4eXll6k3GKlqpI+Ga13vkDS/l50p6wxOgNViUyH4zvXg36c3nTpH6jr1Mg
         d3msfn9ilPhqDaR8msLV7CnmZ3AuznqDo6IowXsp9J4CK8OEJA+7h/wixBXNGlqvm4FY
         WuHaNgWRT5qZeFeFJ18hCr4HvEwn/ZSM6E7ZyZ7Kg/wm93BakIQT/NR5TiGAKZl8uBw4
         lN4dzwFujMHuFiD0+LBOxBWEOIyQyy1NbOqYd8b3xHijtmGV+YXp7IOJBnYuc60jQJBM
         IlSg==
X-Gm-Message-State: APjAAAWbIgYoNsBRuEDkL7SU7zQS+IoXCpiHkLYNrIOVlkshXap1co7k
        f25kEz15EPlgcmdxtez6lWKd1NRqI9l7rV+IqSsv7j7C4XotT3rYGgxgE2VYUmH6QuJvXwToz4o
        DlFne/BoGM3lH
X-Received: by 2002:adf:e6d2:: with SMTP id y18mr32226464wrm.262.1577120965635;
        Mon, 23 Dec 2019 09:09:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxNQPfEA2sNTGfQFSEHBoWItWIFd4rul0NNEzD8hlA+lN7HwX5wQlhvAll+fQlF/OOeNqywhw==
X-Received: by 2002:adf:e6d2:: with SMTP id y18mr32226438wrm.262.1577120965441;
        Mon, 23 Dec 2019 09:09:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id p18sm52547wmg.4.2019.12.23.09.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 09:09:24 -0800 (PST)
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
To:     Liran Alon <liran.alon@oracle.com>,
        John Andersen <john.s.andersen@intel.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20191220192701.23415-1-john.s.andersen@intel.com>
 <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <15b57d6b-0f46-01f5-1f75-b9b55db0611a@redhat.com>
Date:   Mon, 23 Dec 2019 18:09:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/19 15:48, Liran Alon wrote:
>> Should userspace expose the CR pining CPUID feature bit, it must zero CR
>> pinned MSRs on reboot. If it does not, it runs the risk of having the
>> guest enable pinning and subsequently cause general protection faults on
>> next boot due to early boot code setting control registers to values
>> which do not contain the pinned bits.
> 
> Why reset CR pinned MSRs by userspace instead of KVM INIT handling?

Most MSRs are not reset by INIT, are they?

Paolo

