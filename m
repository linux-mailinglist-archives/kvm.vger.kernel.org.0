Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E2253BE7A
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbiFBTOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbiFBTOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:14:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CDD55B1;
        Thu,  2 Jun 2022 12:13:59 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252IpZVS001969;
        Thu, 2 Jun 2022 19:13:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5PbTjA+tugzQl7/AzLcsiOuKxC1vmxclCTwr1s3hXQM=;
 b=QIxRSU1NCFJ86XNYvnBF4SjCkOz016TWuoiTFQK4ZBZFg9FgLXGK5KmX/fQG4XhbShq3
 CJBwsVQPqvhkyW9X6dmD/sx3+ctgyEaboEB2CB4itaLCQfStUFdfdJr1OpXfuyJUqQOL
 3R+Fg2nFvdorrsOUJht1xIuDHQD5qAj5w8qq3vVJdux2YCCO0QGcgYoFt5RmN5Smau+D
 FFJ19t6rGCTGwZ9qoLkdh3PZaSfaudYDq8loxayt2dh/YHbZA6TXNKcVRNGSjYpVaknJ
 pY4ANGOwxmy15uJyll5N05SFP4cxuLhYrLXFDLrbn3GTHqLcWaD7uOvo8VAanxZwN2D1 GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gf2uw8c3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:13:57 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252IpfNv002236;
        Thu, 2 Jun 2022 19:13:56 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gf2uw8c3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:13:56 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252J63fV003352;
        Thu, 2 Jun 2022 19:13:55 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3gbc934g4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:13:55 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252JDrDW14483860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 19:13:54 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E327AC605A;
        Thu,  2 Jun 2022 19:13:53 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EC9EC6055;
        Thu,  2 Jun 2022 19:13:53 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.94.47])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jun 2022 19:13:53 +0000 (GMT)
Message-ID: <61a2989519b1db5099bc8739fd6ce628522feae4.camel@linux.ibm.com>
Subject: Re: [PATCH v1 05/18] vfio/ccw: Remove private->mdev
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Thu, 02 Jun 2022 15:13:52 -0400
In-Reply-To: <20220602190234.GB3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
         <20220602171948.2790690-6-farman@linux.ibm.com>
         <20220602190234.GB3936592@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1HY2iVgN5ZkAeSYAUIHYqSBjZg1FZFaB
X-Proofpoint-GUID: EK9FccY3J362ySZm__dAV6oUMmVgz00h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-02 at 16:02 -0300, Jason Gunthorpe wrote:
> On Thu, Jun 02, 2022 at 07:19:35PM +0200, Eric Farman wrote:
> > @@ -262,7 +260,7 @@ static void fsm_io_request(struct
> > vfio_ccw_private *private,
> >  			errstr = "transport mode";
> >  			goto err_out;
> >  		}
> > -		io_region->ret_code = cp_init(&private->cp,
> > mdev_dev(mdev),
> > +		io_region->ret_code = cp_init(&private->cp, private-
> > >vdev.dev,
> >  					      orb);
> 
> You'll need to rebase this series, I already did this hunk in v5.19:
> 
> commit 0a58795647cd4300470788ffdbff6b29b5f00632
> Author: Jason Gunthorpe <jgg@ziepe.ca>
> Date:   Wed May 11 13:12:59 2022 -0600
> 
>     vfio/ccw: Remove mdev from struct channel_program

Ah, yes. I hadn't gotten this sent out before the vfio pull request
landed yesterday, so a rebase is of course warranted. Thanks!

Eric

> 
> Jason

