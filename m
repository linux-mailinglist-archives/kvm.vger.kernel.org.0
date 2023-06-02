Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB4F720265
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 14:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbjFBMrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 08:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbjFBMrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 08:47:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EDCE63;
        Fri,  2 Jun 2023 05:47:05 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352CjJJe008788;
        Fri, 2 Jun 2023 12:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=r5Vxddmy2HSlIOmeoz4FV7DtWkvwFlQhF6xej4Qy/NQ=;
 b=nm81liY8XzRDYQAMAoWX92O9uNZPjxnc6u1rnpJXwZMlcDY4LgzsIdvNQguG34GqmEDu
 4D8oV9qgPKoPujGM6yI/5HYgmao3/f20sfx+Lu77il7NcBX9lIi3/k2fBWpD3DeaQHhD
 +khs73lz9UwQeFKVNRNjmaKT1uN6CITFifV9EpU+MDh/JO97aMYNh2zO3EGn33eHxz8V
 V/zbjxnqA/i0H1NU/V/594rFC8mwMCueoaiCPKfnmYFApgeUjRZpgc3aIe4eV0V0pybG
 D2PjXLnVoInUkMORt/xodSWUi7rhZ+owUdO2sFJMHjqsPghQFD5AZDwuFyXr8e+7vbgi AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qyfdc2954-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 12:47:04 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 352CjPEk008953;
        Fri, 2 Jun 2023 12:47:03 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qyfdc294s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 12:47:03 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35271oiq024079;
        Fri, 2 Jun 2023 12:47:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qu9g52hn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 12:47:01 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 352Ckw3q19399172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jun 2023 12:46:58 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 394FE2004E;
        Fri,  2 Jun 2023 12:46:58 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 632D420043;
        Fri,  2 Jun 2023 12:46:57 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.36.211])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri,  2 Jun 2023 12:46:57 +0000 (GMT)
Date:   Fri, 2 Jun 2023 14:46:55 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, jjherne@linux.ibm.com,
        pasic@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, Cedric Le Goater <clegoate@redhat.com>
Subject: Re: [PATCH 0/3] s390/vfio-ap: fix hang when mdev attached to guest
 is removed
Message-ID: <ZHnkvxEonzxrVQdA@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
 <30741787-441a-034f-f8d4-9f1060841051@linux.ibm.com>
 <20230601144722.6eba9c49.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601144722.6eba9c49.alex.williamson@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5iSu3tiOUKN3nWDUYNafwFtdRy7FKsOl
X-Proofpoint-ORIG-GUID: cLi3oBdIVKxc8Vr9IsdUvCC2_ayYmm1A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_09,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxlogscore=779 bulkscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 02:47:22PM -0600, Alex Williamson wrote:
...
> > As to how this series eventually reaches master...  It touches both s390 and vfio.  
> > 
> > @Alex/@s390 maintainers -- I suggest it go through s390 given the
> > diffstat, it's almost completely in s390 drivers code.  However there
> > is a uapi hit to vfio.h (in patch 1) that should get at least an ACK
> > from Alex beforehand.
> 
> Ack'd, I'll expect this to go through the s390 tree.  Thanks,

Applied, thanks!

> Alex

