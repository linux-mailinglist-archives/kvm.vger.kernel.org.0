Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D58313F89
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 20:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhBHTuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 14:50:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236379AbhBHTtU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 14:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612813674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fbn7GdaBKVLKbPiuQemPacIJV9xqx2rXfL8BnWQu1BA=;
        b=gBEyZE6yCc2h4CRW7NEaOuW7L2xTjzSmMIi3C3rmFpls/Cl5+N3uz7JohMeIdawubsYMkV
        DGB5emKOT1/GDG3f21PZBnROhLEUSiAJ2ZlamFRMTGrWuKUscZliqeG1LVepwhLg9Nzsw0
        0U0tOf8NiC285S6VmUvpELztKeqRAto=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-plLfX4siNRuutTvuzadnFg-1; Mon, 08 Feb 2021 14:47:52 -0500
X-MC-Unique: plLfX4siNRuutTvuzadnFg-1
Received: by mail-wr1-f71.google.com with SMTP id d7so14092326wri.23
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 11:47:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fbn7GdaBKVLKbPiuQemPacIJV9xqx2rXfL8BnWQu1BA=;
        b=f/w5IvjuYyu+CHuoBL+b8RGYJBMksgBZvzl8QV74JfaQ8oAEbNq+Kyr9hvYInGPpmb
         SX9ZnUTbE98CxX0pqe0lDHQUzAIDWwrBiV+VAqzgpSfgOXA2bxP5FkBCf90LinbISKZ0
         USLUmxRATHbvRXRbftc/l8OXc4DIlx/X2fKhLaG+J+cDTEflxq1YpcsDYet/mWuWexL3
         wq9qkJ9MFOgfCULJflbuc5tVXjYI0F0bNcm0Vckfg8PQts4L/F9l9dDv0juf4kGiE6eZ
         eEx/TsUnWR+O9E9kR5y1gA31EdYf1Xtvnbe+8G6t9WkGJ2Jw7vdsSsId/mDpXelMi5BX
         Cpzg==
X-Gm-Message-State: AOAM532a3f26jCYvpqdE8HX/NCWupHrvvqc9Wt+VXPjXzATsB8+V7Qk6
        ZRBzqad2OyAOw5MuBL9bE8+k1mvISu6DVaON/1svOUo3PN64tfnwNc/LK0y5AsFfiy0/0ttL0dn
        O0wYdT8yGDELlWdq9sDkpWvZklmkvULjRVQGpxC6H5P5w2Mt6IOf74zio8RwUJ4fz
X-Received: by 2002:a5d:5092:: with SMTP id a18mr22056922wrt.380.1612813671253;
        Mon, 08 Feb 2021 11:47:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwARQ4C58IlhAqgbkOSrum8emzTUjTpBZYrfMp7Hx+e0BH4Olv/xtake/poBSSiELcuHYuUmg==
X-Received: by 2002:a5d:4a09:: with SMTP id m9mr21584778wrq.122.1612813299508;
        Mon, 08 Feb 2021 11:41:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d23sm423802wmd.11.2021.02.08.11.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 11:41:36 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: compile out TDP MMU on 32-bit systems
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210206145333.47314-1-pbonzini@redhat.com>
 <YCGQVdPio+LSNWGi@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <24735404-2cde-42a6-14c4-f734da5d5493@redhat.com>
Date:   Mon, 8 Feb 2021 20:41:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YCGQVdPio+LSNWGi@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 20:26, Sean Christopherson wrote:
> This can/should also expand the #ifdef to the TDP-only fields in 
> kvm_mmu_page. I also vote to #ifdef out all of tdp_iter.h, and probably 
> the TDP-only fields in struct kvm_arch. 

Agreed except for tdp_iter.h, I don't see the point since it is not used 
outside tdp_iter.c and tdp_mmu.c.

Paolo

