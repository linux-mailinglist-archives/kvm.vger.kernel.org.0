Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6431683E6
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 17:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgBUQos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 11:44:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39122 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725995AbgBUQor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 11:44:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582303486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WD+egaXL79n8fyoJ4JTqJrgGl0BA5SEmN2Q+iUmm0zI=;
        b=JOXnwZFlHwIC2kkTYkbwq/Fs+8kJL+vJDsJrxkheifty1s79YueSjCOpC7ABOdAmBb11Of
        +tDiUjTpAIhxqe98Erjo3m8YfyOoETl7AF+knQrOe4F2f9W9F5d0J4aKjYDVMvKLDK/rLd
        SD2F3AT3Ig+cFU/W7YVzadMnhK857EQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-zcg1i7ioNw-66-QroLGlAw-1; Fri, 21 Feb 2020 11:44:44 -0500
X-MC-Unique: zcg1i7ioNw-66-QroLGlAw-1
Received: by mail-qk1-f197.google.com with SMTP id q123so2130979qkb.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 08:44:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WD+egaXL79n8fyoJ4JTqJrgGl0BA5SEmN2Q+iUmm0zI=;
        b=ln0sDfq8waaSpW7q/4y2qtIyb+/8ap344GphxcBf1nWPehd8YUcupRNGlKF1C9dgVb
         dNUiS1lMDOh7SKSBo8Y3HJr6CYZJ8Ar5feOLYJ63+xQJfswc+PF3Zb2VFto2qw+xAIYO
         rSUwxwqe2dibdhl3mTHUXinrVRkabT0gKSG7/krMp46chqhDj2b8SH4c0LUDp7p1LoE/
         AwizexpnnTqeha9w72Gyys7ulQ9VzCFjbzI6eiRiv4+aXDu0pVio6nrBE/QJDc/chW3v
         MS5QMR5bRuVarjszWJ16JwB27RDcWLET9nVliWL3dRV4WULF4l3TOdFbRLBKuZ3fRopm
         6H9w==
X-Gm-Message-State: APjAAAUVl/R6mq/DUrdHCXYzDTtwgqB7ME5kHtj0wGCovVdrQsXVwdW+
        XmC24IOEIXjFRaUQoTJu8H9S8X5cUQed8RHZSBVDXpjW7OBF+vRQduwLKbWC0o5KDWY3Nj2xUzx
        bMSh266kCke8F
X-Received: by 2002:ac8:349d:: with SMTP id w29mr33243891qtb.386.1582303484277;
        Fri, 21 Feb 2020 08:44:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqxQoOdWwadLGptmbzYnJV0Fm1g9q1W92mP2ra2dLjU3WlXAcaUfoHYvaEIMeYHVuFYpjg8gdg==
X-Received: by 2002:ac8:349d:: with SMTP id w29mr33243876qtb.386.1582303484083;
        Fri, 21 Feb 2020 08:44:44 -0800 (PST)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id o7sm1769967qkd.119.2020.02.21.08.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 08:44:43 -0800 (PST)
Date:   Fri, 21 Feb 2020 11:44:42 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH] accel/kvm: Check ioctl(KVM_SET_USER_MEMORY_REGION)
 return value
Message-ID: <20200221164442.GD37727@xz-x1>
References: <20200221163336.2362-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200221163336.2362-1-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 05:33:36PM +0100, Philippe Mathieu-Daudé wrote:
> kvm_vm_ioctl() can fail, check its return value, and log an error
> when it failed. This fixes Coverity CID 1412229:
> 
>   Unchecked return value (CHECKED_RETURN)
> 
>   check_return: Calling kvm_vm_ioctl without checking return value
> 
> Reported-by: Coverity (CID 1412229)
> Fixes: 235e8982ad3 ("support using KVM_MEM_READONLY flag for regions")
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

