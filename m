Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44463502619
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 09:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350943AbiDOHUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 03:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350773AbiDOHUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 03:20:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349A8AAB44
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 00:18:26 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D547C68B05; Fri, 15 Apr 2022 09:18:22 +0200 (CEST)
Date:   Fri, 15 Apr 2022 09:18:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 01/10] kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into
 functions
Message-ID: <20220415071822.GA24824@lst.de>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <1-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
