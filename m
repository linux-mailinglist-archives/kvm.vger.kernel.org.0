Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5916E24B637
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 12:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgHTKTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 06:19:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55006 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731379AbgHTKTW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 06:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597918760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=34Fudio4VU2L9NDM258KSxl3iDnftB/ysyHG0W39VZc=;
        b=hNqLU63ZEFUtY+a5phIHdRevvjdrctzYsDmXOtuPFzx8oRidBr5vqmWltvX03guLVZikiD
        /c9h6/BXPeL4ka5pnQ3RXiEZ6hjbuJxhGjLOJHCZpMjxioU0jPPFQcn+yYqvz+qrnGLQv/
        jXW710cJeMNBEr6uGxJ+WWn4jwLBPXQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-WuRJHWAMPe6O5-P12n9Iwg-1; Thu, 20 Aug 2020 06:19:19 -0400
X-MC-Unique: WuRJHWAMPe6O5-P12n9Iwg-1
Received: by mail-wm1-f70.google.com with SMTP id d22so620706wmd.2
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 03:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=34Fudio4VU2L9NDM258KSxl3iDnftB/ysyHG0W39VZc=;
        b=QNnc0tqNEZxQjNSBU8AfkuZJG232cBCOf6LpEFwDRtG25G5Mh2szxsaGZBmk4pRD1a
         xTwuQ+cT131PUwyPjz1CWVOldCPVVFgc9YneHz8WS2rcNtEqXnQYE1NvEIekYq5bXuka
         JZDVV7Lv7Xkm4jRcCuHkJprbogHminmjc9jAzaw/Z5STVE6ZnWqqga1ZkjR4sD8kh+sh
         Bk8geXpywaQDfzYhMQzrh2eRqI9Ahkq+n/SvdRByffVohF/IhNeTfk77d7RC+BoyYngg
         G04iym8WrghTowFjvtsQ4Ovme30Mhb5D6LrXCe3vuoPkdJk6NQpYegV7zagIaiWeJdNZ
         K8JQ==
X-Gm-Message-State: AOAM532IdzrqBmjbJslW6h4tN5WQf92NJ9Bh6jS1fz6pCGmAp/8zz2MU
        gAK7B53GGFUyWpuUNsTDFOB3HDXTRY+JhY0N4cV3H2BF+HzbnRxHBIJ0lngHvht/L4sfqwE3837
        6dgnzKo83FKfs
X-Received: by 2002:a5d:538a:: with SMTP id d10mr2629011wrv.280.1597918757986;
        Thu, 20 Aug 2020 03:19:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcmOd0V2f8YQ+GGOMTGELWjIMpMo5QSR9ODiDyEBM79MegWciDEkcINCLPVWrrTLa38NO7ew==
X-Received: by 2002:a5d:538a:: with SMTP id d10mr2628987wrv.280.1597918757808;
        Thu, 20 Aug 2020 03:19:17 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id d11sm3113354wrw.77.2020.08.20.03.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 03:19:17 -0700 (PDT)
Subject: Re: [PATCH 2/8] KVM: nSVM: rename nested 'vmcb' to vmcb_gpa in few
 places
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
 <20200820091327.197807-3-mlevitsk@redhat.com>
 <f6bf9494-f337-2e53-6e6c-e0b8a847ec8d@redhat.com>
 <608fe03082dc5e4db142afe3c0eb5f7c165f342b.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e8185af-08fc-18c3-c1ca-fa1f7d4665dd@redhat.com>
Date:   Thu, 20 Aug 2020 12:19:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <608fe03082dc5e4db142afe3c0eb5f7c165f342b.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/20 12:00, Maxim Levitsky wrote:
>> Please use vmcb12_gpa, and svm->nested.vmcb12 for the VMCB in patch 6.
>>
>> (You probably also what to have local variables named vmcb12 in patch 6
>> to avoid too-long lines).
> The limit was raised to 100 chars recently, thats why I allowed some lines to
> go over 80 characters to avoid adding too much noise.
> 

True, but having svm->nested.vmcb12->control repeated all over isn't
pretty. :)

Since you're going to touch all lines anyway, adding the local variable
is a good idea.

Paolo

