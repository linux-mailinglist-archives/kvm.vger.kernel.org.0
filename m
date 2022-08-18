Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AE4597FC1
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 10:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244010AbiHRIE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 04:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240356AbiHRIE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 04:04:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB8B6B8FA;
        Thu, 18 Aug 2022 01:04:56 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27I7qSC8004059;
        Thu, 18 Aug 2022 08:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=d9/IoJLc0k+bSkJU+0AY+sj4CSQp3FbnOb1W0cKbLhU=;
 b=mt1/f/jim1XscfPoRTnECBp6YObFTg6Et9t51fryFByIhu2FLPHuH1zvuVDBQEWjPqEI
 0NSOagKErprQQEgmXUeOzQ/OhsFqb9x6f6Tb0VIn7NKdxK4qt4aJkssowmnd9EHUzyOA
 BltqIkirDVrmwo9F3nQOP14hgLu5roDQB8lZj4CQKso79DyNvTGdtwe9NLWOBbYYjSV1
 qtjjB52OU/0HCUyvvudq1uRO2Zoo8kTqPaOVZEEoxdZpcFRCEO3n2lsyPERQvRYf4MBk
 t25wteHWFwu/Ka9rnX/jjVa2+ZspfUfQRyDIP/TrQBJzeIjbx+0pCJXkorwKPYbysetz AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1hdp8ba3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 08:04:54 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27I7vxUg020795;
        Thu, 18 Aug 2022 08:04:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1hdp8b97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 08:04:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27I7oH6u019867;
        Thu, 18 Aug 2022 08:04:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3hx3k8whyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 08:04:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27I821xo25035086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 08:02:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 416B2AE053;
        Thu, 18 Aug 2022 08:04:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5B71AE045;
        Thu, 18 Aug 2022 08:04:47 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.17.18])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 18 Aug 2022 08:04:47 +0000 (GMT)
Date:   Thu, 18 Aug 2022 10:04:46 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH 0/2] s390/vfio-ap: fix two problems discovered in the
 vfio_ap driver
Message-ID: <Yv3ynhVYegld5MsO@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20220817225242.188805-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817225242.188805-1-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z3PFzFEDMlgNzjNt9aMokVoMQc4ZMlzO
X-Proofpoint-GUID: HxUaGertC9txwSh598lezo0-xotfAzUI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_02,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=777 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0
 clxscore=1011 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180025
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 06:52:40PM -0400, Tony Krowiak wrote:
> Two problems have been discovered with the vfio_ap device driver since the
> hot plug support was recently introduced:

Hi Tony,

Could you please add Fixes tags to the patches?

Thanks!
