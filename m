Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F57962DCC
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 04:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfGIB6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 21:58:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45759 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfGIB6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 21:58:12 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so8451772pfq.12
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 18:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zyDIO7yh1oeZpbiIlgCyaK7CcmNyJU5JiEZyTWaMNxE=;
        b=fcANcTySMBtikvChnLyNCMEAUfJc/sm0Cr1GrWP8+6rW/PIjOpnhyMhxBEhu+/PArf
         CkzaKl6v7dAASswjon9jza/Rb/5/6/NHzf4rmN0GlBG7W/IdKhh/xHzIRt6hw/YHx+Ju
         9nQPlZEUvbRhh1XQKL+oS8q5qR4k8iqH+8nQyk60fcQhKrMpozrCSpyoyNcM6MDxIhc9
         YIHdmHFw1OaxJ42vjcxnfMY01BUJ+A7r6BDVmJygEybc3Wo9tbv1o3WNqI4/1mcQhcL0
         wZEsgMLfKJyk8cQ+EIuJws92KBcK6zt8yRhqg5KQWHoRznHq8f0tHm++7fDN5wPE7gUQ
         F/jg==
X-Gm-Message-State: APjAAAUZ8/IBNtbpyfu5bUQYuLzIXFQIfzY/amcdGQlk16SSsZ28yfEO
        urMTkMmdY0rmdynHofpfdfc8FQ==
X-Google-Smtp-Source: APXvYqxmQP3po9nC79ae7wUEpZA4moIQW5XJjcBpq0lp52WdTJOCFmyLLLg8W6qA/qwHlulZNIUK8w==
X-Received: by 2002:a63:7a4f:: with SMTP id j15mr28036729pgn.427.1562637491766;
        Mon, 08 Jul 2019 18:58:11 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i3sm22605155pfo.138.2019.07.08.18.58.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 18:58:10 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Tue, 9 Jul 2019 09:58:00 +0800
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 02/18] linux-headers: import vfio.h from kernel
Message-ID: <20190709015800.GA566@xz-x1>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-3-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1562324511-2910-3-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 07:01:35PM +0800, Liu Yi L wrote:
> This patch imports the vIOMMU related definitions from kernel
> uapi/vfio.h. e.g. pasid allocation, guest pasid bind, guest pasid
> table bind and guest iommu cache invalidation.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>

Just a note that in the last version you can use
scripts/update-linux-headers.sh to update the headers.  For this RFC
it's perfectly fine.

-- 
Peter Xu
