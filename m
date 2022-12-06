Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F239B6440FE
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 11:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiLFKKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 05:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbiLFKJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 05:09:55 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D160C19;
        Tue,  6 Dec 2022 02:02:43 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B69BvaU013651;
        Tue, 6 Dec 2022 10:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=QNu8Jj7AVVudaYbX+CLTPbYHaoKOb8+SjzNWwWSo7XA=;
 b=DpSW7QsSjHzPUOkMFctKYTqkU68e3Z5X+BgGgX5zxMsnf/pTTVYV/30iHYF1AU8gCufd
 vCI/Q1IYtARi93bY0iCzxdVWipuPutoJRpDAC8al1k/IjxsCLH0TNGIoV4cabknCXqQ9
 l/xe1tvUecFLDhUz2qO9epxtEUCkOHZgCkAx5+pWalyW8N29b6W++SCp5U1r7zhnBkN1
 LfUs9Y+/exvH2NdMr9jNoanNOVLb5+kjCNPQNMCSq9R/xmCywCj4ilHwnZH9i+7sqnhI
 ccEKJq1MUHkd2YR94X2aYreqbmCKeEv/gevP4zWV+94v7na8OWeKZtdQfBLul15sDXAr 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m9tqmbyrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:02:33 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B69bMWK030126;
        Tue, 6 Dec 2022 10:02:32 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m9tqmbyr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:02:32 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B5K5OEu004999;
        Tue, 6 Dec 2022 10:02:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3m9pv9rpfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:02:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com ([9.149.105.59])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6A2RUE15991256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 10:02:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11647A405B;
        Tue,  6 Dec 2022 10:02:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2BE8A405F;
        Tue,  6 Dec 2022 10:02:26 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 10:02:26 +0000 (GMT)
Date:   Tue, 6 Dec 2022 11:02:25 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ruanjinjie <ruanjinjie@huawei.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] vfio/ap/ccw/samples: Fix device_register() unwind path
Message-ID: <20221206110225.681a9bd6.pasic@linux.ibm.com>
In-Reply-To: <166999942139.645727.12439756512449846442.stgit@omen>
References: <166999942139.645727.12439756512449846442.stgit@omen>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T2ceiqn4SxTJEVVT7PQjC69AhBnGbf1A
X-Proofpoint-ORIG-GUID: _fkZvVWHgNptlThpDeqDHDI_N-rxUbhG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_05,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 02 Dec 2022 09:46:15 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> We always need to call put_device() if device_register() fails.
> All vfio drivers calling device_register() include a similar unwind
> stack via gotos, therefore split device_unregister() into its
> device_del() and put_device() components in the unwind path, and
> add a goto target to handle only the put_device() requirement.
> 
> Reported-by: Ruan Jinjie <ruanjinjie@huawei.com>
> Link: https://lore.kernel.org/all/20221118032827.3725190-1-ruanjinjie@huawei.com
> Fixes: d61fc96f47fd ("sample: vfio mdev display - host device")
> Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
> Fixes: a5e6e6505f38 ("sample: vfio bochs vbe display (host device for bochs-drm)")
> Fixes: 9e6f07cd1eaa ("vfio/ccw: create a parent struct")
> Fixes: 36360658eb5a ("s390: vfio_ap: link the vfio_ap devices to the vfio_ap bus subsystem")
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
