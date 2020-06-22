Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF4F203AB3
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 17:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgFVPXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 11:23:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31807 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729049AbgFVPXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 11:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592839432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGpF0Z4o98o6k0v3vIzdGQK4IxCExf5QSKDcyS94Xvc=;
        b=WIzqC71X0A5hN4gOoXemTu/J+1yvz80y1jvPYSibdSKjR1ZKagJQeRVM+YbkbwPdic1C9o
        ibBWhrgXrP9pTFWPmbMj+B3Gehohy/Tfm5IjYNjdSodvExbdGT3CCQkzHl19bPaIcXo3Mc
        GLvs6Ass6OeGnxsyzVbGpUJ3Jn5BG2w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-s9pgzdDDOYmK0-UM3_gaow-1; Mon, 22 Jun 2020 11:23:51 -0400
X-MC-Unique: s9pgzdDDOYmK0-UM3_gaow-1
Received: by mail-wm1-f69.google.com with SMTP id s134so5755894wme.6
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 08:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wGpF0Z4o98o6k0v3vIzdGQK4IxCExf5QSKDcyS94Xvc=;
        b=f9Xv4LAcbFFa8VxvHFrrh5WA32anrK8loHBwoAdCGVHfJ32lkKaVXpptyLBn99bWNL
         5jENpiS8tljRn1U6uMO+MBu7mgh2WRi4ZqoycD2Pv5Uy6SdtwRtVcVzAhV+gqursB8zM
         XzPsHZjFPyQGGKD4Wf1ijMEzB7WCkrHLApnNQqibVRHUCe6c6zKCGj/BTNH0yawsIL1z
         LBbaFfEkmC4Jg7eEEWf77yUZJcHJhQK18fFzjN3CeUgD/zAYM4yiuvn1J14odhG4/1gp
         BRx0tVacgsOZ4RxHqYH9Ao9sBfih+PjrExuObkS8HytlvFo6nEr+UPRHGphnM96X9LAK
         VRUw==
X-Gm-Message-State: AOAM533fB++7QGkd3+Y0At+Z2d6ycZFo+mH3w9H635GWvLeZpBnd/34H
        YIJ2H++Fbq/+hcXc8nqxMAyY0oF0RQWZ8lCSOssclvgPIgTp2HSmdGuluRBUhoW2uDA46zTJeQJ
        wESe4dhhyTZHn
X-Received: by 2002:adf:ef46:: with SMTP id c6mr1166994wrp.34.1592839429933;
        Mon, 22 Jun 2020 08:23:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJvSRmLdiYDCgpOU1rHgnpl7Ep95bf98pJLlBYjznBMbbO5UABy+Hb03Ct9Xk8BS49lBEPeA==
X-Received: by 2002:adf:ef46:: with SMTP id c6mr1166972wrp.34.1592839429751;
        Mon, 22 Jun 2020 08:23:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id 63sm19975505wra.86.2020.06.22.08.23.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 08:23:49 -0700 (PDT)
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Mohammed Gamal <mgamal@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <a5793938619c1c328b8283aab90166e352071317.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <08594d32-9be2-b4d6-1dac-a335e8bda9f7@redhat.com>
Date:   Mon, 22 Jun 2020 17:23:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <a5793938619c1c328b8283aab90166e352071317.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 17:08, Mohammed Gamal wrote:
>> Also, something to consider. On AMD, when memory encryption is 
>> enabled (via the SYS_CFG MSR), a guest can actually have a larger
>> MAXPHYADDR than the host. How do these patches all play into that?

As long as the NPT page tables handle the guest MAXPHYADDR just fine,
there's no need to do anything.  I think that's the case?

Paolo

> Well the patches definitely don't address that case. It's assumed a
> guest VM's MAXPHYADDR <= host MAXPHYADDR, and hence we handle the case
> where a guests's physical address space is smaller and try to trap
> faults that may go unnoticed by the host.
> 
> My question is in the case of guest MAXPHYADDR > host MAXPHYADDR, do we
> expect somehow that there might be guest physical addresses that
> contain what the host could see as reserved bits? And how'd the host
> handle that?

