Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F390B255C54
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 16:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgH1OYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 10:24:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26070 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726871AbgH1OYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 10:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598624645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qm4yw14oZW1kOamiCPd98+q7tZwl+c/TO08c6jDr94k=;
        b=C7j6jrItVMCieRNx3cbjEcKhJ1tODwxO2T/xYEhc1D6su05L+vrzTH0toqCEIdS4844INV
        /gZOyYDW0JL9rRhyrUVeEjaekPpV12roYLzHNpJ4MqI1wd1IVTrybU0SilQ9svlfFnmNkt
        7nnGiUCKlWwZI097KDfKzBwOe/YnBdE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-CAo84l5HOGaxLjH1nhax0A-1; Fri, 28 Aug 2020 10:24:04 -0400
X-MC-Unique: CAo84l5HOGaxLjH1nhax0A-1
Received: by mail-qv1-f70.google.com with SMTP id l10so886455qvw.22
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 07:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qm4yw14oZW1kOamiCPd98+q7tZwl+c/TO08c6jDr94k=;
        b=aEjSOybQpspAN3IREdUv9Gbc9l9veQYeWeFY9DGhIc/74yRbS+teX+1J0iSV05y0e0
         dqvNIC7u6N3JtgnKlzeS4t9ZWEJQvETAdNw4lxRrYD00/e6F7psEuNRc0+CzoIOE5iGS
         K+7n5g4/J9bghtLc5SF0EWV1itd9ySHWoZM3mFfljxSNn5mIADd3P70UyxGnUVrGqOWI
         raP86aVV9XG8OZcQY4wtVabUTwTGVG+10b2JBIrL1k/3MZusnNjh6HWEmQ4ypscTD8hH
         EqnIOSIhFouG8ubGaEKKhIy1DypmQBiMXH5yIbG4uzeNBRHXaMu5tLy2a9ktww2OzIfc
         Crbg==
X-Gm-Message-State: AOAM532Yd44NBYZO2RN2BnYEr8iiDYy6Zlc995lHOQ2reOVKCDVsOTlI
        9X71rypCQiv2IBZZPLgW15jIfJagWtjtVtI6yiASgR6Wvnl9PLuic0tZzP9aomXQaXwTk6RaZ1c
        Sy2mnQ6wkxK7O
X-Received: by 2002:a0c:dd05:: with SMTP id u5mr1964740qvk.143.1598624643650;
        Fri, 28 Aug 2020 07:24:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyS2SFjk0+xV0FK90qlNWVxFACNOzmy1EjYy0Kne2/gImeDcKsxIYjVyoXkR34UqhH/MeqiCg==
X-Received: by 2002:a0c:dd05:: with SMTP id u5mr1964698qvk.143.1598624643273;
        Fri, 28 Aug 2020 07:24:03 -0700 (PDT)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-11-70-53-122-15.dsl.bell.ca. [70.53.122.15])
        by smtp.gmail.com with ESMTPSA id w3sm886056qkc.10.2020.08.28.07.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 07:24:02 -0700 (PDT)
Date:   Fri, 28 Aug 2020 10:24:00 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Maoming (maoming, Cloud Infrastructure Service Product Dept.)" 
        <maoming.maoming@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        wangyunjian <wangyunjian@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRD?= =?utf-8?Q?H?= V2] vfio
 dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200828142400.GA3197@xz-x1>
References: <20200814023729.2270-1-maoming.maoming@huawei.com>
 <20200825205907.GB8235@xz-x1>
 <8B561EC9A4D13649A62CF60D3A8E8CB28C2D9ABB@dggeml524-mbx.china.huawei.com>
 <20200826151509.GD8235@xz-x1>
 <8B561EC9A4D13649A62CF60D3A8E8CB28C2DBE7A@dggeml524-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8B561EC9A4D13649A62CF60D3A8E8CB28C2DBE7A@dggeml524-mbx.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 09:23:08AM +0000, Maoming (maoming, Cloud Infrastructure Service Product Dept.) wrote:
> In hugetlb_put_pfn(), I delete unpin_user_pages_dirty_lock() and use some simple code to put hugetlb pages.
> Is this right?

I think we should still use the APIs because of the the same reason.  However
again I don't know the performance impact of that to your patch, but I still
think that could be done inside gup itself when needed (e.g., a special path
for hugetlbfs for [un]pinning continuous pages; though if that's the case that
could be something to be discussed on -mm then as a separate patch, imho).

Thanks,

-- 
Peter Xu

