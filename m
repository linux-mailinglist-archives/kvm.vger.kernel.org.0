Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5983841379D
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 18:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhIUQes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 12:34:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhIUQep (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 12:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632241996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AgdgXL0GX40Z7joIZyMMmmnhD5sqv/4MqfHkboNgGCc=;
        b=SzohkBQwXIKm9qKfA6gvemutJRhC4YfsI7fbAu6fTaj4jTTtqly/rW9GF7Yrb5Qt25Ux/N
        U39Cto48HrOcmnrVHwEVYWFvwR69/KgMnG7AOraxBTqdu0SUm37bCive/EZnRLbCKuOJf9
        DujN1XpQLupMamiN9CVLaz9uswcfXGY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-rwgPzUT1OMSzFYg_NHcolg-1; Tue, 21 Sep 2021 12:33:15 -0400
X-MC-Unique: rwgPzUT1OMSzFYg_NHcolg-1
Received: by mail-ed1-f71.google.com with SMTP id m30-20020a50999e000000b003cdd7680c8cso19559538edb.11
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 09:33:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AgdgXL0GX40Z7joIZyMMmmnhD5sqv/4MqfHkboNgGCc=;
        b=srDoTZkagO+b+HKhx1fEvKTAEF6kVxnDwIyKK8eQKj4gtl5diuOISPvT/yLXv2RlhL
         jms6mPZDnRVaQ2asIrR414H/eXhqUYBqdBzCG7yuPiqvb55aMHvhTKgb+DdMck7Vznui
         350DBoGdgi4s22lEICk0Y0W+iXYAj3AOnXVs9FRld9tWRx1J+H/cUEyQxFoap2KlX1YU
         EI3qpsgB0noQV9Vt85mKhla9qqWWSUBNNJEteMMYFBz9StwC6k+9JCxIGCvk8FE5YgvW
         410PYWkotXRQacfKq9ZsUUyplQA5k6U59vbUIG9bgz1ikfrAHKzofYAbKYy1KhN+Puf0
         nacQ==
X-Gm-Message-State: AOAM531L+KlMCIMLtcTU088wsW8dAlPcEOxwvKx02g9H1lx0Omxsq8YE
        4V/o09Ud69WVZiNQ5F6iNWqzEqEVhLAtbYEuSa0l0/3OTGX3f7XpSfBndtawQkG+9Xukk89qX8B
        zhNJo8TGkwVLO
X-Received: by 2002:aa7:d649:: with SMTP id v9mr37205853edr.38.1632241994192;
        Tue, 21 Sep 2021 09:33:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMGW/y1xj4rKgd2s2x/cn7/ItkmczQTAVEMs0o/j64ZHHHDArfWkeloQASN4zZ77lVHHYvFg==
X-Received: by 2002:aa7:d649:: with SMTP id v9mr37205826edr.38.1632241993995;
        Tue, 21 Sep 2021 09:33:13 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id d7sm1288219eds.42.2021.09.21.09.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:33:13 -0700 (PDT)
Date:   Tue, 21 Sep 2021 18:33:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zixuanwang@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, marcorr@google.com,
        baekhw@google.com, tmroeder@google.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 01/17] x86 UEFI: Copy code from Linux
Message-ID: <20210921163311.deya72m7z2dkmhgc@gator.home>
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-2-zixuanwang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827031222.2778522-2-zixuanwang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 03:12:06AM +0000, Zixuan Wang wrote:
> From: Varad Gautam <varad.gautam@suse.com>
> 
> Copy UEFI-related definitions from Linux, so the follow-up commits can
> develop UEFI function calls based on these definitions, without relying
> on GNU-EFI library.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/linux/uefi.h | 518 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 518 insertions(+)
>  create mode 100644 lib/linux/uefi.h
> 
> diff --git a/lib/linux/uefi.h b/lib/linux/uefi.h
> new file mode 100644
> index 0000000..567cddc
> --- /dev/null
> +++ b/lib/linux/uefi.h

Any reason to rename this to uefi.h even though it's efi.h in Linux?

Usually I'd suggest we take the whole file from Linux (but that would
be a mess for this one, so no) or that we only take what we need, when
we need it, rather than dumping a bunch of stuff up front which may or
may not be needed. Skimming through though, it looks like we'll likely
need most the stuff brought over. So I guess I'm OK with this approach.

Thanks,
drew

