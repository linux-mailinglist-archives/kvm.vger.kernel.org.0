Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7643465142B
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 21:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiLSUoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 15:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiLSUoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 15:44:16 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4E2F5D;
        Mon, 19 Dec 2022 12:44:14 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJKSBhM013490;
        Mon, 19 Dec 2022 20:44:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oNZe1fIhVqueh4fcLdp1UMOJ9QvWJpJWMLx0ihVtUOw=;
 b=aDybF5d7iaAHtHL7U8TCpwiYGOaim69y8Mj2hFTmJFwoAuP+ZpUFxszb2sQ0IFiHyAZR
 Jw4nyBibUy+KmCp5ztlZCa5DF3+kqGNnCWP58PQwRiQcQuCNMvji9AnVWwjERSDk1OcQ
 Viou+LT5u4+SVdZSSajRaLo+q9KtFpi8q7EMsiyU3K8P0N8o5Iq+STV8zbSkrzQzrFrU
 mrckQnkjJLM78pClLSll7dnwoR9YX4eolYLcybPqWkOLASyd7lzHyh2A6ML2XAyXyNjA
 5CAFlU6wrr2hbdvANU5+uJoJmQbT/yYF+zClWCPhtRsogjtQ6BKU1WrpljNws9yoJb3z 4Q== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjy0yh13a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:44:13 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJK1VNk027516;
        Mon, 19 Dec 2022 20:44:13 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mh6yukk27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:44:13 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJKiB3p5767756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 20:44:11 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CC2558059;
        Mon, 19 Dec 2022 20:44:11 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EF9558058;
        Mon, 19 Dec 2022 20:44:10 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 20:44:09 +0000 (GMT)
Message-ID: <a93ee944-ff4c-d62a-5e6e-7fa9f4c7c031@linux.ibm.com>
Date:   Mon, 19 Dec 2022 15:44:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 16/16] vfio/ccw: remove old IDA format restrictions
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20221121214056.1187700-1-farman@linux.ibm.com>
 <20221121214056.1187700-17-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-17-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: THLZY_LIrJi1UjNpMQOYgsivdZi7FcdV
X-Proofpoint-GUID: THLZY_LIrJi1UjNpMQOYgsivdZi7FcdV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190181
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> By this point, all the pieces are in place to properly support
> a 2K Format-2 IDAL, and to convert a guest Format-1 IDAL to
> the 2K Format-2 variety. Let's remove the fence that prohibits
> them, and allow a guest to submit them if desired.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  Documentation/s390/vfio-ccw.rst | 4 ++--
>  drivers/s390/cio/vfio_ccw_cp.c  | 8 --------
>  2 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
> index ea928a3806f4..53375dc86213 100644
> --- a/Documentation/s390/vfio-ccw.rst
> +++ b/Documentation/s390/vfio-ccw.rst
> @@ -219,8 +219,8 @@ values may occur:
>    The operation was successful.
>  
>  ``-EOPNOTSUPP``
> -  The orb specified transport mode or an unidentified IDAW format, or the
> -  scsw specified a function other than the start function.
> +  The ORB specified transport mode, or the

Nit:  Drop unnecessary comma

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> +  SCSW specified a function other than the start function.
>  
>  ``-EIO``
>    A request was issued while the device was not in a state ready to accept
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 3829c346583c..60e972042979 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -372,14 +372,6 @@ static int ccwchain_calc_length(u64 iova, struct channel_program *cp)
>  	do {
>  		cnt++;
>  
> -		/*
> -		 * As we don't want to fail direct addressing even if the
> -		 * orb specified one of the unsupported formats, we defer
> -		 * checking for IDAWs in unsupported formats to here.
> -		 */
> -		if ((!cp->orb.cmd.c64 || cp->orb.cmd.i2k) && ccw_is_idal(ccw))
> -			return -EOPNOTSUPP;
> -
>  		/*
>  		 * We want to keep counting if the current CCW has the
>  		 * command-chaining flag enabled, or if it is a TIC CCW

