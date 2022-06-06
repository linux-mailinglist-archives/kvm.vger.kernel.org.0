Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8C853EF8F
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbiFFUZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbiFFUYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:24:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9E43D1D7;
        Mon,  6 Jun 2022 13:23:47 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256IW3ZM005625;
        Mon, 6 Jun 2022 20:23:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=faXoE+gBCXN6zlpwc5+B4mhsBjpCPQHG0yympeKmS4E=;
 b=Y9Jl3EbObhzBfmEfsKdCljW2Dxt17VxzemMJBEwJzAFvlIZL+V8jXTOLpJ2IwwY2pWqp
 97/8ikVGJqWpfWURsQdRTEYGTSGPptB2ddKUPOQWkMBOQfyXkq6FefAR1QMqBDO2wgVm
 fGopePwlmz/SabApj/KF8+s7tnMhru8P/E+xxw2o7YLuRQEBmTX0QtyZFvU8g7tKKWWz
 ckU4N5WmEkj/FyHntmk80luX7K8NGlnIo7QPKivfCrTzSa8GekudNI9jwAdLeiLKnVNa
 Ac9AzXIa90CL3wsQ8fR/p6cPCbVFFAe9ZuwAK839TbMFomBN6/wS2eYNbRfMHlRX8cBJ sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghpxphugh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:23:41 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256K8Aq3038844;
        Mon, 6 Jun 2022 20:23:40 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghpxphug7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:23:40 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KKGJX030481;
        Mon, 6 Jun 2022 20:23:39 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3gfy19fu7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:23:39 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KNcaM22675888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:23:38 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 219C313604F;
        Mon,  6 Jun 2022 20:23:38 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB1B8136051;
        Mon,  6 Jun 2022 20:23:36 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.94.47])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:23:36 +0000 (GMT)
Message-ID: <c818e1ef24c466a3b1d14d4ab10163d5e349a3b4.camel@linux.ibm.com>
Subject: Re: [PATCH v1 14/18] vfio/mdev: Add mdev available instance
 checking to the core
From:   Eric Farman <farman@linux.ibm.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Date:   Mon, 06 Jun 2022 16:23:36 -0400
In-Reply-To: <63a87e1e-7d99-b091-4c6b-fa25dd7c5211@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
         <20220602171948.2790690-15-farman@linux.ibm.com>
         <63a87e1e-7d99-b091-4c6b-fa25dd7c5211@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ufsn8hNjVsc7tPBkwT3P9943Tw80ERSr
X-Proofpoint-GUID: 7gGCeLIfYcdFYigrkuEUsEFRMm5lQ5ms
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 bulkscore=0 clxscore=1011 mlxscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-07 at 01:32 +0530, Kirti Wankhede wrote:
> 
> On 6/2/2022 10:49 PM, Eric Farman wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Many of the mdev drivers use a simple counter for keeping track of
> > the
> > available instances. Move this code to the core code and store the
> > counter
> > in the mdev_type. Implement it using correct locking, fixing mdpy.
> > 
> > Drivers provide a get_available() callback to set the number of
> > available
> > instances for their mtypes which is fixed at registration time. The
> > core
> > provides a standard sysfs attribute to return the
> > available_instances.
> > 
> > Cc: Kirti Wankhede <kwankhede@nvidia.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> > Cc: Jason Herne <jjherne@linux.ibm.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Link: 
> > https://lore.kernel.org/r/7-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com/
> > [farman: added Cc: tags]
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >   .../driver-api/vfio-mediated-device.rst       |  4 +-
> >   drivers/s390/cio/vfio_ccw_drv.c               |  1 -
> >   drivers/s390/cio/vfio_ccw_ops.c               | 26 ++++---------
> >   drivers/s390/cio/vfio_ccw_private.h           |  2 -
> >   drivers/s390/crypto/vfio_ap_ops.c             | 32 ++++--------
> > ----
> >   drivers/s390/crypto/vfio_ap_private.h         |  2 -
> >   drivers/vfio/mdev/mdev_core.c                 | 11 +++++-
> >   drivers/vfio/mdev/mdev_private.h              |  2 +
> >   drivers/vfio/mdev/mdev_sysfs.c                | 37
> > +++++++++++++++++++
> >   include/linux/mdev.h                          |  2 +
> >   samples/vfio-mdev/mdpy.c                      | 22 +++--------
> >   11 files changed, 76 insertions(+), 65 deletions(-)
> > 
> > diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> > b/Documentation/driver-api/vfio-mediated-device.rst
> > index f410a1cd98bb..a4f7f1362fa8 100644
> > --- a/Documentation/driver-api/vfio-mediated-device.rst
> > +++ b/Documentation/driver-api/vfio-mediated-device.rst
> > @@ -106,6 +106,7 @@ structure to represent a mediated device's
> > driver::
> >   	     int  (*probe)  (struct mdev_device *dev);
> >   	     void (*remove) (struct mdev_device *dev);
> >   	     struct device_driver    driver;
> > +	     unsigned int (*get_available)(struct mdev_type *mtype);
> >        };
> > 
> 
> This patch conflicts with Christoph Hellwig's patch. I see 
> 'supported_type_groups' is not is above structure, I beleive that
> your 
> patch is applied on top of Christoph's patch series.
> 
> but then in below part of code, 'add_mdev_supported_type' has also
> being 
> removed in Christoph's patch. So this patch would not get applied
> cleanly.

Apologies. This series was fit to 5.18 as the merge window progressed.
Both this patch and the previous one have to adjust to the removal of
mdev_parent_ops that came about from 

commit 6b42f491e17ce13f5ff7f2d1f49c73a0f4c47b20
Author: Jason Gunthorpe <jgg@ziepe.ca>
Date:   Mon Apr 11 16:14:01 2022 +0200

    vfio/mdev: Remove mdev_parent_ops

I have this rebased for v2.

Eric

> 
> Thanks,
> Kirti
> 
> > +/* mdev_type attribute used by drivers that have an
> > get_available() op */
> > +static ssize_t available_instances_show(struct mdev_type *mtype,
> > +					struct mdev_type_attribute
> > *attr,
> > +					char *buf)
> > +{
> > +	unsigned int available;
> > +
> > +	mutex_lock(&mdev_list_lock);
> > +	available = mtype->available;
> > +	mutex_unlock(&mdev_list_lock);
> > +
> > +	return sysfs_emit(buf, "%u\n", available);
> > +}
> > +static MDEV_TYPE_ATTR_RO(available_instances);
> > +static umode_t available_instances_is_visible(struct kobject
> > *kobj,
> > +					      struct attribute *attr,
> > int n)
> > +{
> > +	struct mdev_type *type = to_mdev_type(kobj);
> > +
> > +	if (!type->parent->ops->device_driver->get_available)
> > +		return 0;
> > +	return attr->mode;
> > +}
> > +static struct attribute *mdev_types_name_attrs[] = {
> > +	&mdev_type_attr_available_instances.attr,
> > +	NULL,
> > +};
> > +static struct attribute_group mdev_type_available_instances_group
> > = {
> > +	.attrs = mdev_types_name_attrs,
> > +	.is_visible = available_instances_is_visible,
> > +};
> > +
> >   static const struct attribute_group *mdev_type_groups[] = {
> >   	&mdev_type_std_group,
> > +	&mdev_type_available_instances_group,
> >   	NULL,
> >   };
> >   
> > @@ -136,6 +169,10 @@ static struct mdev_type
> > *add_mdev_supported_type(struct mdev_parent *parent,
> >   	mdev_get_parent(parent);
> >   	type->type_group_id = type_group_id;
> >   
> > +	if (parent->ops->device_driver->get_available)
> > +		type->available =
> > +			parent->ops->device_driver-
> > >get_available(type);
> > +
> >   	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
> >   				   "%s-%s", dev_driver_string(parent-
> > >dev),
> >   				   group->name);
> > diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> > index 14655215417b..0ce1bb3dabd0 100644
> > --- a/include/linux/mdev.h
> > +++ b/include/linux/mdev.h
> > @@ -120,12 +120,14 @@ struct mdev_type_attribute {
> >    * @probe: called when new device created
> >    * @remove: called when device removed
> >    * @driver: device driver structure
> > + * @get_available: Return the max number of instances that can be
> > created
> >    *
> >    **/
> >   struct mdev_driver {
> >   	int (*probe)(struct mdev_device *dev);
> >   	void (*remove)(struct mdev_device *dev);
> >   	struct device_driver driver;
> > +	unsigned int (*get_available)(struct mdev_type *mtype);
> >   };
> >   

