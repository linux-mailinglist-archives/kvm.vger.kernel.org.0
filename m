Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4363D47D7
	for <lists+kvm@lfdr.de>; Sat, 24 Jul 2021 15:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhGXMnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jul 2021 08:43:32 -0400
Received: from verein.lst.de ([213.95.11.211]:40790 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230449AbhGXMnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jul 2021 08:43:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7AB6467373; Sat, 24 Jul 2021 15:24:00 +0200 (CEST)
Date:   Sat, 24 Jul 2021 15:24:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: s390 common I/O layer locking
Message-ID: <20210724132400.GA19006@lst.de>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <20210428190949.4360afb7.cohuck@redhat.com> <20210428172008.GV1370958@nvidia.com> <20210429135855.443b7a1b.cohuck@redhat.com> <20210429181347.GA3414759@nvidia.com> <20210430143140.378904bf.cohuck@redhat.com> <20210430171908.GD1370958@nvidia.com> <20210503125440.0acd7c1f.cohuck@redhat.com> <292442e8-3b1a-56c4-b974-05e8b358ba64@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <292442e8-3b1a-56c4-b974-05e8b358ba64@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021 at 05:10:42PM +0200, Vineeth Vijayan wrote:
>> For the css bus, we need locking for the event callbacks; for irq, this
>> may interact with the subchannel lock and likely needs some care.
>>
>> I also looked at the other busses in the common I/O layer: scm looks
>> good at a glance, ccwgroup and ccw have locking for online/offline; the
>> other callbacks for the ccw drivers probably need to take the device
>> lock as well.
>>
>> Common I/O layer maintainers, does that look right?
>>
> I just had a quick glance on the CIO layer drivers. And at first look, you 
> are right.
> It looks likewe need modifications in the event callbacks (referring css 
> here)
> Let me go thoughthis thoroughly and update.

Did this go anywhere?
