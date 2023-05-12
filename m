Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A67B700C0B
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 17:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbjELPi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 11:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjELPiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 11:38:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA4135A7;
        Fri, 12 May 2023 08:38:54 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34CFEbaO014439;
        Fri, 12 May 2023 15:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=97f9UGa5HYz+f/llJQR7fEEzPzbWJk+BZt5ibp0YWDM=;
 b=WeFaTjADdhzS9A5BNggScNVT/oPrAwAgqjSwEFvdTBB/qNdOgMyYyF8TqdH9jGmY2Vqw
 bnsO15MeCw4EIgLRiR4C9jQ0L9GI8ZDTL8oUchsdEH8MRvkM4eNaynBL+OjmiWoWdIeN
 q34PMozL2UWJP3pdTYxskpdybtuBIqV+lsW5JeYguLCiU8mnF9c6wPB9I/Zq5FV4bqVg
 2xT9+BoM4+dplJ3ZocNDyAGZH7ij4O+P4w9hZkDPrKHNiCGG082ZqWtsUsrKCHBLDxgh
 69blp+JNdEOhJaZjZynIFA58mm1RxAVUU3SLi3RAHYEU9M3eNPYN3/7F2vR/ilZ94lyg 4Q== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhk83247k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 15:38:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34CE8TcD003948;
        Fri, 12 May 2023 15:34:28 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qf7s8j0ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 15:34:28 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34CFYOZF46268684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 15:34:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2D862004B;
        Fri, 12 May 2023 15:34:24 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CD8420040;
        Fri, 12 May 2023 15:34:24 +0000 (GMT)
Received: from osiris (unknown [9.179.20.70])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 12 May 2023 15:34:24 +0000 (GMT)
Date:   Fri, 12 May 2023 17:34:22 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: Re: [PATCH 5/5] s390/uv: Update query for secret-UVCs
Message-ID: <ZF5cfisjdpiFX/L7@osiris>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
 <20230512093153.206378-6-seiden@linux.ibm.com>
 <ZF42vescJsAtK9pL@osiris>
 <b826b914-a3dc-488d-b4d8-23dbfee29e58@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b826b914-a3dc-488d-b4d8-23dbfee29e58@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ykx9P2LUQ-KUQE1GgLeNXXfL0uFQqFe_
X-Proofpoint-GUID: Ykx9P2LUQ-KUQE1GgLeNXXfL0uFQqFe_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_09,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=842 lowpriorityscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120129
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 03:27:52PM +0200, Janosch Frank wrote:
> On 5/12/23 14:53, Heiko Carstens wrote:
> > On Fri, May 12, 2023 at 11:31:53AM +0200, Steffen Eiden wrote:
> > > Update the query struct such that secret-UVC related
> > > information can be parsed.
> > > Add sysfs files for these new values.
> > > 
> > > Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> > > ---
> > >   arch/s390/boot/uv.c        |  4 ++++
> > >   arch/s390/include/asm/uv.h | 11 ++++++++++-
> > >   arch/s390/kernel/uv.c      | 40 ++++++++++++++++++++++++++++++++++++++
> > >   3 files changed, 54 insertions(+), 1 deletion(-)
> > ...
> > > +static ssize_t uv_query_supp_add_secret_req_ver(struct kobject *kobj,
> > > +						struct kobj_attribute *attr, char *page)
> > > +{
> > > +	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_add_secret_req_ver);
> > > +}
> > 
> > FWIW, another minor thing: all of these should be sysfs_emit() instead.
> 
> Do you want us to move all of them to sysfs_emit() eventually or should we
> keep the scnprintfs() which are already in uv.c ?

I'd convert the existing ones as well.
