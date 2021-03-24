Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE84234781C
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 13:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhCXMRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 08:17:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233486AbhCXMRH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 08:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616588226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E9F49iv0iMvNhK2Ha5Psl89snw9CgCXbICGGoRQHqgo=;
        b=agjR4kAMkGySspKyhL8flrXd2Gx0ZFy6mZ1GNF0oy2a/SoDKfWuhZblDdTaN57Z2X5dc7I
        F9dLwAf1iHcBW0osNLpBY6glAZYKj0nkGH+Ls6Rvy3QTOS8U8ycbnyaS0TWsPYVUOC4dt7
        0SsacyKDJ91cmvgMMkFD6TaCN5UlHqc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-VlH0Oy-YOFumTvszzqCIVQ-1; Wed, 24 Mar 2021 08:17:03 -0400
X-MC-Unique: VlH0Oy-YOFumTvszzqCIVQ-1
Received: by mail-wr1-f72.google.com with SMTP id b6so981815wrq.22
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 05:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E9F49iv0iMvNhK2Ha5Psl89snw9CgCXbICGGoRQHqgo=;
        b=J92OFySwNr3O2cSGdUEhHA4T0IVoPQSWcFA5ZfmBLYmO2yfrG585CU0fmyklOgADpr
         oJ6pejrhhN5CLV4rnvrPdr2stPyWlOXjPBvL4kpUQ4+Aeb9w+AKvbI7ubpW+FwX4buYc
         va+HXQ8BuWxb+JfcElYxQ6UjFB70Ia9ot9VoBJPn3OtMxXefDEEf+UjqrlX4ITYeqFIk
         U1kcbi4T4ONpAi0ROFDRXPewDf3YW0gxggNqHfN1jgFcLkY74aPcTD/F1OW3B+v2mZ1Y
         1i6lkwbbZ3uRWr/NkbRnXu0GpJZTJ1EK4PspnUb40yhkF9qyhHMouGfzDJv8kohrrO4A
         /4DQ==
X-Gm-Message-State: AOAM531rkwPCXAxuw0SCkYekEfneemMehFlhe2TI9FgtFawu3yCRVor7
        veYBZXT3nkp+vmTwAxigumpb/yBV6OOp8QJScOOLivAyU1dPDtpDBBULQgrD7No0ra+whiVmWRL
        J+Y8pIBZI9iFn
X-Received: by 2002:a1c:10f:: with SMTP id 15mr2732457wmb.14.1616588222693;
        Wed, 24 Mar 2021 05:17:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeb/ON+kOZdzKfxRLK6YPN7H/+pVhXU/ZCNGdjNz0SXLH6TmVovV6hD5q+z3+Sl9n5adX/sQ==
X-Received: by 2002:a1c:10f:: with SMTP id 15mr2732435wmb.14.1616588222507;
        Wed, 24 Mar 2021 05:17:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id c131sm2362100wma.37.2021.03.24.05.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 05:17:01 -0700 (PDT)
Subject: Re: [syzbot] possible deadlock in kvm_synchronize_tsc
To:     syzbot <syzbot+9a89b866d3fc11acc3b6@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <00000000000099aa6805be432fce@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dd9de982-e94d-163f-067b-d86d95e947a8@redhat.com>
Date:   Wed, 24 Mar 2021 13:17:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <00000000000099aa6805be432fce@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/21 08:24, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1c273e10 Merge tag 'zonefs-5.12-rc4' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1063d14ed00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6abda3336c698a07
> dashboard link: https://syzkaller.appspot.com/bug?extid=9a89b866d3fc11acc3b6
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bf56f6d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=174e36dcd00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9a89b866d3fc11acc3b6@syzkaller.appspotmail.com

#syz dup: possible deadlock in scheduler_tick

