Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476672314A2
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 23:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgG1VcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 17:32:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38067 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729348AbgG1VcI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 17:32:08 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2020 17:32:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595971927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xP4ZM/Jlocue76wtrooa1rGgir9thUsOWzhW0hP2Vz4=;
        b=dIqwS8qKliBQoakHxRPFIQqUuAQG8eHJvXOUaBvOr3RCinlZRcMqYDF2O5ss4/rpph1HYl
        QNzzbmcLyee+P0RzSFWIGdEz8SYmGtHbkq7Ve0rOD1KCmWLbIFRUjTU6amJZT+ogLQ4rJI
        GnIi5AIIFZfCDAwq6+AkGW01EgUh7L8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-tYcUFJBRMUy2LIS8VTxYhA-1; Tue, 28 Jul 2020 17:25:56 -0400
X-MC-Unique: tYcUFJBRMUy2LIS8VTxYhA-1
Received: by mail-wr1-f72.google.com with SMTP id 5so5722957wrc.17
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 14:25:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xP4ZM/Jlocue76wtrooa1rGgir9thUsOWzhW0hP2Vz4=;
        b=P/VFwK/ZKOtHCPlVk1ZoyvyiSQQoghkocyLYHAn5Puv9S93nClGgVPASxaMGrcICBv
         1GEWXiM2nRi1jC2sxb6epbOv2lEcYIUUy8vgYPNkN3VUXqRyT9L/excqifEdafbZ/EGp
         MoSqcW0ik6PBjV6EB0hJxsgqE53PUP6L5X/cC9hMVfoypu8XAe9KAxM8E60vxkvfueX4
         RT9mp7ZxqYklDJr9DFmU9c0BoR4q/QJERXc6JqsXFo3Cnvy1eM3n9Flg7hS0anVEAESC
         WEsg73r1a7R1SvJkGgABbb8kgdOkhXXqzRd152roEOXQApjtnK0lAnKHk8dgglJkEvsW
         66UQ==
X-Gm-Message-State: AOAM530gufmueh2pxc1j598lO3xlvHFi3tKy6cJvbKg+mcCjQtapNKB5
        l2iMcMxrhlQoNIoZnL+S9thMCjzM2fpjh4TpX+yNpmdzULOrFu6UIaCmMANHDIWU7kabsFAIB67
        nY4rY9WfcnE+6
X-Received: by 2002:adf:dbce:: with SMTP id e14mr26158191wrj.244.1595971554942;
        Tue, 28 Jul 2020 14:25:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIKNrlOnfrpyKfK/qYZn4kcbmPTNc8qCaO32B8dh44ThItakf43cD5vQGHUYl5anf4DfIhUw==
X-Received: by 2002:adf:dbce:: with SMTP id e14mr26158176wrj.244.1595971554770;
        Tue, 28 Jul 2020 14:25:54 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id y84sm173205wmg.38.2020.07.28.14.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 14:25:54 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Fix some compilation issues on
 32bit
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
References: <20200714130030.56037-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8d90b625-567d-e1b1-8533-996d654594f8@redhat.com>
Date:   Tue, 28 Jul 2020 23:25:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200714130030.56037-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/07/20 15:00, Claudio Imbrenda wrote:
> Two small patches to fix compilation issues on 32bit:
> 
> one for a typo in x86/cstart
> 
> one for a thinko in lib/alloc_page
> 
> notice that there is another patch for the lib/alloc_page issue floating
> around, this patch is an alternative to that one
> 
> v1->v2
> * use the z modifier for size_t variables, instead of casting to long
> 
> Claudio Imbrenda (2):
>   x86/cstart: Fix compilation issue in 32 bit mode
>   lib/alloc_page: Fix compilation issue on 32bit archs
> 
>  lib/alloc_page.c | 4 ++--
>  x86/cstart.S     | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 

Queued these, thanks.

Paolo

