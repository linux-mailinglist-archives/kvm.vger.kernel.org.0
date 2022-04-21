Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5CD5096E8
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 07:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384505AbiDUFml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 01:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345361AbiDUFm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 01:42:29 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9351120A5
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 22:39:41 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 21AC168B05; Thu, 21 Apr 2022 07:39:39 +0200 (CEST)
Date:   Thu, 21 Apr 2022 07:39:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 4/8] vfio: Remove vfio_external_group_match_file()
Message-ID: <20220421053938.GB20660@lst.de>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com> <4-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

