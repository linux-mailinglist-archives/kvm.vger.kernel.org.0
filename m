Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BE916430B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 12:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgBSLK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 06:10:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50317 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726487AbgBSLKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 06:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582110654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G9ngAADFf0H6tNXWrWk3zBJLW6Dh0uOu2zK7HumFKqU=;
        b=fjn8BEAhHJQ2Vsl/2d5uOdVCNBqJg1olIv4zM3ucAGAXqPB8w60hhUhJKhXMI59N4uw4yQ
        aEnjGsl0fzK3dn4XDtj752g6Nzuiee8yvKvN6zzuzEzc9xH6zJjXxoFK4X1vSCggXMR1O2
        JECEaXKtEhtOXP5iOeKTAGRbbFzs6X0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-k5HsDmYkPNqe45OOn9oz_w-1; Wed, 19 Feb 2020 06:10:52 -0500
X-MC-Unique: k5HsDmYkPNqe45OOn9oz_w-1
Received: by mail-wr1-f69.google.com with SMTP id m15so12320227wrs.22
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 03:10:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G9ngAADFf0H6tNXWrWk3zBJLW6Dh0uOu2zK7HumFKqU=;
        b=eu+ur599g9OAllK8IEGDxfUsk5HevPF6kQVp+xmV7mmmSmPMFG1srSs5R5vr/8zt4o
         LGLONg77iKAiF88eM/DcnuTHkec8Evc7LcosRcMajiRJ1GZw7ZNoDnGa+XpSYr9Gvs5P
         zHEKepE89MQ/wIzHmvcy3WyPkqRbfHx1zvjiu+V6kPdmI2W22CudFcQN/BlzIV5BX4+l
         cStZmSbSZu6cOO020oHqPtwVcrOD/KZa8TwRqLOQZ94/iEsjxoCC0L82tM6LbMPII/Qf
         RNqbtGXK34mvQ+2ijomdsi+e7kNunzruUWbO8n+HY1K+cGDkroCOFz80n2efJS1MFrkE
         C5kQ==
X-Gm-Message-State: APjAAAU+zgKjDS+yQm4Ner5W5keMVAB8qL5WA0LTeywXyBT3p/Dx16Au
        86xCZtbSHd7FDrr/SSkbdo/MpwuF6WhJLpgLt6bQ24y2sZet9B2bOHVuri/oHjlyTU/rL9kfL7v
        8qjSUzoIn3AKM
X-Received: by 2002:a7b:c183:: with SMTP id y3mr8994471wmi.45.1582110651008;
        Wed, 19 Feb 2020 03:10:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqxgHklSoTJAASymtkOJdhkIhiMJIFRI+F05r4Zs/xNP/kGoNa/TNx+0pu+EJD1dPQoyvi+MUw==
X-Received: by 2002:a7b:c183:: with SMTP id y3mr8994454wmi.45.1582110650820;
        Wed, 19 Feb 2020 03:10:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ec41:5e57:ff4d:8e51? ([2001:b07:6468:f312:ec41:5e57:ff4d:8e51])
        by smtp.gmail.com with ESMTPSA id e1sm2438009wrt.84.2020.02.19.03.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 03:10:50 -0800 (PST)
Subject: Re: [RFC] eventfd: add EFD_AUTORESET flag
To:     Avi Kivity <avi@scylladb.com>, Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <20200129172010.162215-1-stefanha@redhat.com>
 <66566792-58a4-bf65-6723-7d2887c84160@redhat.com>
 <20200212102912.GA464050@stefanha-x1.localdomain>
 <156cb709-282a-ddb6-6f34-82b4bb211f73@redhat.com>
 <cadb4320-4717-1a41-dfb5-bb782fd0a5da@scylladb.com>
 <20200219103704.GA1076032@stefanha-x1.localdomain>
 <c5ea733d-b766-041b-30b9-a9a9b5167462@scylladb.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ced21f4f-9e8a-7c61-8f50-cee33b74a210@redhat.com>
Date:   Wed, 19 Feb 2020 12:10:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <c5ea733d-b766-041b-30b9-a9a9b5167462@scylladb.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/02/20 11:43, Avi Kivity wrote:
> 
>> Thanks, that's a nice idea!  I already have experimental io_uring fd
>> monitoring code written for QEMU and will extend it to use
>> IORING_OP_READ.
> 
> Note linux-aio can do IOCB_CMD_POLL, starting with 4.19.

That was on the todo list, but io_uring came first. :)

Paolo

