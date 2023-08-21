Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9B1782ED0
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 18:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbjHUQwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 12:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236802AbjHUQwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 12:52:15 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CA710D
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 09:52:03 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-76da8e70ed3so56697885a.3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 09:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1692636722; x=1693241522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JkXwy1ISt6qrbrNZuCCq5IPH6kF6shpR2kgu96JJrek=;
        b=TUUsTkKH5URw0jANzhVv1T58xuhiQN8AoY56op+SMW6dJqqBZda8RDoywrFBQnuz3+
         iff2uk5g1UgRlXxQW+tuJj5yXCU9V7wWqr+lJGapFySbk7mC/eKW4FLVNyoSMxUXFRBR
         YvQUQ9o2y3GI5GGSue750glVwG2u7MFOxOCO5h2V29DOhKsRMpSKdlGvpr3jWwjWcFcH
         1VdQFHzo8a9pOqW+rhaOE2f7GTAfUNz3vidG+5vsqK97r4+gSZQlv/3IiBU9xx6Mrym9
         Klab9eqEoCmD6EKz3OXjW4iANZ5nY0A0aWKyinVKVgiV6PJ83olsWG1alZ2kOZyzlZiw
         qTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692636722; x=1693241522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JkXwy1ISt6qrbrNZuCCq5IPH6kF6shpR2kgu96JJrek=;
        b=fyK5cBbfq1dG8XsQweXL6GxHEYiAgWCb1ZAOfG7uHdDS2qtjdfLq7s245CsjwJ7TXk
         ESLgiXo2gxki2RmQGB0WX6F3qqAGI074oVzRRI3rVolZ5Dg1uOjWhEbw4Zq0XPHvaF/Q
         eqcrdVmqM8XiZlgbLF8zOBmiqf4EGs+LVq/iEclS3R0CTXWLPry/2ch7v0zDpqVQu6ol
         xhTlwHhPH8LVS9SbwwSfmIwxDP36rxrDqbuEqOCfoEB0dth/Hus0nfjIwgXJqed5TzaZ
         WwcubDOClUHNIIFYA3k5fmu/djhO19O/9J5tNEmd5FSSo25erUh+4pMJnh7fY+KZNigb
         UVHQ==
X-Gm-Message-State: AOJu0Yz9dQSOK6cQbqlMjX2sAmRXpfOQpW5/KWedVbbJu4ouJ5UiubhN
        Mje2BuYp8MAs1jhOHXpclsqUlQ==
X-Google-Smtp-Source: AGHT+IGIrArLMUjqUVsv2NQ4VGh6eVA/ApKYhx1ONwSB7QRBGzVgS5K5zRFadfQ4B9TvLMlxOhAyww==
X-Received: by 2002:a05:620a:bd5:b0:76c:9ea2:545e with SMTP id s21-20020a05620a0bd500b0076c9ea2545emr8795157qki.3.1692636722684;
        Mon, 21 Aug 2023 09:52:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id a5-20020a05620a124500b0076d9e298928sm1589751qkl.66.2023.08.21.09.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 09:52:02 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qY88H-00DuJL-7T;
        Mon, 21 Aug 2023 13:52:01 -0300
Date:   Mon, 21 Aug 2023 13:52:01 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Huang Jiaqing <jiaqing.huang@intel.com>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, joro@8bytes.org, will@kernel.org,
        robin.murphy@arm.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com
Subject: Re: [PATCH] iommu/vt-d: Introduce a rb_tree for looking up device
Message-ID: <ZOOWMUmwG2jXOaXL@ziepe.ca>
References: <20230821071659.123981-1-jiaqing.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821071659.123981-1-jiaqing.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023 at 12:16:59AM -0700, Huang Jiaqing wrote:
> The existing IO page fault handler locates the PCI device by calling
> pci_get_domain_bus_and_slot(), which searches the list of all PCI
> devices until the desired PCI device is found. This is inefficient
> because the algorithm efficiency of searching a list is O(n). In the
> critical path of handling an IO page fault, this can cause a significant
> performance bottleneck.
> 
> To improve the performance of the IO page fault handler, replace
> pci_get_domain_bus_and_slot() with a local red-black tree. A red-black
> tree is a self-balancing binary search tree, which means that the
> average time complexity of searching a red-black tree is O(log(n)). This
> is significantly faster than O(n), so it can significantly improve the
> performance of the IO page fault handler.
> 
> In addition, we can only insert the affected devices (those that have IO
> page fault enabled) into the red-black tree. This can further improve
> the performance of the IO page fault handler.
> 
> Signed-off-by: Huang Jiaqing <jiaqing.huang@intel.com>
> ---
>  drivers/iommu/intel/iommu.c | 68 +++++++++++++++++++++++++++++++++++++
>  drivers/iommu/intel/iommu.h |  8 +++++
>  drivers/iommu/intel/svm.c   | 13 +++----
>  3 files changed, 81 insertions(+), 8 deletions(-)

I feel like this should be a helper library provided by the core
code, doesn't every PRI driver basically need the same thing?

Jason
