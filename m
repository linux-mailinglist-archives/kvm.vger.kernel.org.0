Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C96D13556E
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 10:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgAIJSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 04:18:04 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29304 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728946AbgAIJSD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 04:18:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578561482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhaeYA2g23tahw81bCX4+JNhyu6u4RRAwh7IDkx1918=;
        b=bGnDETQzzeZax0eCTDGKnCN0Ta1vUPJN28FTE3ah/o77oHtmA4j1EQmbAKwKABitgfncwh
        voCrtFnPZF87SQnG+WADQxcJuF6gOwkpESHufl++GRoGLh9ThmOG1xt5Rjj3aFKC3PqxRQ
        Vjo+iRJDr7EKLQCkH9BkdtOboFlaCKU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-mjqPSOfpOpyTtDeGYs3Tww-1; Thu, 09 Jan 2020 04:18:00 -0500
X-MC-Unique: mjqPSOfpOpyTtDeGYs3Tww-1
Received: by mail-wr1-f71.google.com with SMTP id c17so2627239wrp.10
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 01:18:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AhaeYA2g23tahw81bCX4+JNhyu6u4RRAwh7IDkx1918=;
        b=hchGcL3qM9aXOhX5alO/8UcI5KKfGRU3Xb1aa2ynwNrqYqXx4RtC3HzjkHLzCu/Y76
         YGZOfJCJm43gSEP4+lddRlZAw7Fo0QThjYDVH6WTvaT63KxXmNK4lpVlZCbG1Bc5S379
         S3shI06bJF02cI0WS6cY4oALbGag9xTn6WNi6Q3/JRZEK88GWrjZfyEbDT0HNqQvWP9s
         P9CXllBpRGR2m+0ReMGsHwQrn4c3dzLAcRNVriXb2eFLs+lf5fzGN+Pl1FB/ydkeoWSh
         gyXTvlPZFSJGLhonPF/+xZA8THK3FYb26Jfd5/qAQXCe7TqaAVGe21h+HaokZQNqT1By
         QYUA==
X-Gm-Message-State: APjAAAVpTFh1eX9A5tRFdpYY0FwrLsLPtO7y3ZkllksydPggpis+IdIn
        UUe3Wu8T/crtfmM1hBVR0vJ3ELObmad1/hTt+Vvh3WUk0EMzX5XRsB0Bxe0jFyLUfV498w7hGWt
        sOb6N9UDxZ8KM
X-Received: by 2002:a7b:c750:: with SMTP id w16mr3790726wmk.46.1578561479819;
        Thu, 09 Jan 2020 01:17:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwO/dp4Cv+K4wJ8IJ78LS47uYQP/OWWxk4SqeWOvUxwR2mRP46F42N3prbiEGm8IMPofT1Feg==
X-Received: by 2002:a7b:c750:: with SMTP id w16mr3790701wmk.46.1578561479621;
        Thu, 09 Jan 2020 01:17:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id b18sm7575835wru.50.2020.01.09.01.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 01:17:59 -0800 (PST)
Subject: Re: [PATCH next] KVM: Fix debugfs_simple_attr.cocci warnings
To:     Nicolai Stange <nstange@suse.de>
Cc:     Chen Wandun <chenwandun@huawei.com>, rkrcmar@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1577151674-67949-1-git-send-email-chenwandun@huawei.com>
 <4f193d99-ee9b-5217-c2f6-3a8a96bf1534@redhat.com> <87h816nsv9.fsf@suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5d75e57a-4d04-e6b9-1bbd-a01072bfa6b1@redhat.com>
Date:   Thu, 9 Jan 2020 10:17:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87h816nsv9.fsf@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 11:29, Nicolai Stange wrote:
> 
> How about introducing a
>   #define debugfs_create_attr debugfs_create_file_unsafe
> instead to make those
> s/DEFINE_SIMPLE_ATTRIBUTE/DEFINE_DEBUGFS_ATTRIBUTE/
> patches look less scary?

I agree that could be worthwhile.  My main complaint is the "scariness
factor" of the patches that convert DEFINE_SIMPLE_ATTRIBUTE to
DEFINE_DEBUGFS_ATTRIBUTE, and this change would alleviate that problem.

Thanks,

Paolo

