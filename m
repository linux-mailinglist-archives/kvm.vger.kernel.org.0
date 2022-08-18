Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC1159840A
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 15:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245045AbiHRNYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 09:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245042AbiHRNYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 09:24:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564D64D830;
        Thu, 18 Aug 2022 06:24:33 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27IDElxQ021635;
        Thu, 18 Aug 2022 13:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=oEnoQKatwS/weaS8nuKh/mzNFVQUm91B3qmODlsm3Lc=;
 b=ePnS7ppWBHr3yz/wRP2XLBFCLcB5mDxonQmgS3tk4NVMPGXaTeVXTkp0pA7R6lk/J1RW
 5az61erR79dUsyiJzD3WmviwjM74lEHpBQAqDHhkEsVKg9r0I43IhfZg19MkeYpaMeGP
 lMXj7ld/qCdDO0QghdLX4GN6SPE5iKy3er7n6yJXgisZaOMYvJ0YKlHn+DqJRvN96KEh
 tzWv5PByls1A6ES9mSuaJ1Lofa0A1nIjFA7GL/GXHPJuFYMk/AmoW9+VB2fca+9PGBiW
 G9i37YbbHHQEu1EBE+4JS8WQuN2QBHbseM5hMT7bBcrWDPiCk58GzqPxe7GNWz5C2Vq1 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1p50r7hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:24:26 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27IDGi8Q001691;
        Thu, 18 Aug 2022 13:24:25 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1p50r7gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:24:25 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IDK1cT000487;
        Thu, 18 Aug 2022 13:24:23 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3hx3ka6ywx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:24:23 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IDOMmW5243422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 13:24:22 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C92D3C6055;
        Thu, 18 Aug 2022 13:24:22 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ED94C6057;
        Thu, 18 Aug 2022 13:24:21 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.160.42.126])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 13:24:21 +0000 (GMT)
Message-ID: <0ee29bd6583f17f0ee4ec0769fa50e8ea6703623.camel@linux.ibm.com>
Subject: Re: [RFC PATCH] vfio/ccw: Move mdev stuff out of struct subchannel
From:   Eric Farman <farman@linux.ibm.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>, "hch@lst.de" <hch@lst.de>
Cc:     "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Date:   Thu, 18 Aug 2022 09:24:20 -0400
In-Reply-To: <BN9PR11MB5276B1A7E2901A2A553D13938C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220720050629.GA6076@lst.de>
         <20220726153725.2573294-1-farman@linux.ibm.com>
         <BN9PR11MB5276B1A7E2901A2A553D13938C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RDDEByaWTuHCy0dIjWxVZQ7UTQDOHl5m
X-Proofpoint-ORIG-GUID: DnT4ZBTcLnp8TPbN_TxsYZhh2cl800fk
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 malwarescore=0 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=859
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208180045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-08-18 at 06:53 +0000, Tian, Kevin wrote:
> Hi, Eric,
>=20
> > From: Eric Farman
> > Sent: Tuesday, July 26, 2022 11:37 PM
> >=20
> > --- a/drivers/s390/cio/vfio_ccw_private.h
> > +++ b/drivers/s390/cio/vfio_ccw_private.h
> > @@ -111,6 +111,10 @@ struct vfio_ccw_private {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct eventfd_ctx=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*req_trigger;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct work_struct=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0io_work;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct work_struct=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0crw_work;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mdev_parent=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0parent;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mdev_type=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mdev_type;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mdev_type=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*mdev_types[1];
> > =C2=A0} __aligned(8);
> >=20
>=20
> IMHO creating a separate structure to encapsulate parent related
> information is far cleaner than mixing both mdev and parent into
> one structure.
>=20
> mdev and parent have different life cycles. mdev is between
> mdev probe/remove while parent is between css probe/remove.

I don't disagree with any of that. My point with the suggested patch
was a way to get this working without disrupting the cio's subchannel
(which is used for many non-mdev things).

Un-mixing the mdev from the parent stuff wouldn't be impossible, but
requires consideration I haven't had the bandwidth to do (which is why
the cleanup you reference below was dropped from later versions of that
series [3]).

Thanks,
Eric

[3]
https://lore.kernel.org/all/20220615203318.3830778-1-farman@linux.ibm.com/

>=20
> Mixing them together prevents further cleanup in vfio core [1]
> which you posted in earlier series and also other upcoming
> improvements [2].
>=20
> Thanks
> Kevin
>=20
> [1]
> https://lore.kernel.org/all/20220602171948.2790690-16-farman@linux.ibm.co=
m/
> [2]
> https://listman.redhat.com/archives/libvir-list/2022-August/233482.html

