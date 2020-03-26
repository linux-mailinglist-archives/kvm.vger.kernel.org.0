Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC207193BEC
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 10:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgCZJdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 05:33:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40094 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727699AbgCZJdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 05:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D7iUfyyuqm+dw4598KbpWIu+GERU4Vqzux8/iRw3Pco=; b=F6JlYzTiE+9B++gXkAJKN3WCxV
        xWwamyGhjsFIpTTEiZN042yCZfOx7/WEBR+9I4WHpGyGUs0oazlAvy9UJ4SmSW35mN3rfl2IA3lfR
        Niw5LZyeb2oojAHa0fYTjZEAWUqqOayoJPg8jTMXN3Px173WZEwiNsjQdhyl6CRIWTw/NoSVBLv84
        DHTNLHasfYNNfophQ+se8/udStYa7K/hpOWKIBIA7h8D6BgoUVWf79Pft/YBAUMBtE89HdJBXH2N/
        ajqcfx5Gc0BmlcoU2M4eD0w2EXPaBKcA3kGZuqwb8iZCnK4sZZqDIho14z/yBpzbzcBpx94aF0xpy
        iyedccrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHOsw-0003Fy-SL; Thu, 26 Mar 2020 09:33:10 +0000
Date:   Thu, 26 Mar 2020 02:33:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     alex.williamson@redhat.com, cjia@nvidia.com, kevin.tian@intel.com,
        ziye.yang@intel.com, changpeng.liu@intel.com, yi.l.liu@intel.com,
        mlevitsk@redhat.com, eskultet@redhat.com, cohuck@redhat.com,
        dgilbert@redhat.com, jonathan.davies@nutanix.com,
        eauger@redhat.com, aik@ozlabs.ru, pasic@linux.ibm.com,
        felipe@nutanix.com, Zhengxiao.zx@alibaba-inc.com,
        shuangtai.tst@alibaba-inc.com, Ken.Xue@amd.com,
        zhi.a.wang@intel.com, yan.y.zhao@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v15 Kernel 1/7] vfio: KABI for migration interface for
 device state
Message-ID: <20200326093310.GA12078@infradead.org>
References: <1584649004-8285-1-git-send-email-kwankhede@nvidia.com>
 <1584649004-8285-2-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584649004-8285-2-git-send-email-kwankhede@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/KABI/UAPI/ in the subject and anywhere else in the series.

Please avoid __packed__ structures and just properly pad them, they
have a major performance impact on some platforms and will cause
compiler warnings when taking addresses of members.
