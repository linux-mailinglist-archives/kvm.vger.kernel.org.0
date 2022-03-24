Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AB44E67F3
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 18:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346078AbiCXRmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 13:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239035AbiCXRmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 13:42:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A488AB2444;
        Thu, 24 Mar 2022 10:41:07 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22OHNWvo013340;
        Thu, 24 Mar 2022 17:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=93uZEPHIV2SZO4q0AC6EW0DwGFYFWS7ghnhAGIZJxsI=;
 b=VDaH/QsssIGr4UqJgh7gpJvKj4oosxIwvI2vO4FK5DSm1ll6Jy2PTEDvuZqD59QsjePI
 QMCPzP0yEoqTPTlSzzVd/+eqy3YSTKsMjmpnrJy8dTv6KDnbKJ+1eeolBQRjuUscC2ri
 TZ68amHIW/huBPJsx5RsbagDlRp2poXlM9GeiyiOXR+MUGYR8QjZ7sx7ZQH8jhT0Lr/P
 SUmfZUE6N7iPHNToK3+lIZzijc4eyim9uZo94ycNQXQxHcnI/Or8SN1EaIKA5F1RcAlQ
 Y0fY5GaK2klQIzwUPtjoSo4QJceeVGws+4z7o8RoNDIIZI+DagFi1YOOxC0v3Wvi2sh9 fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0sd3wk6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 17:41:06 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22OHLHI0009603;
        Thu, 24 Mar 2022 17:41:06 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0sd3wk63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 17:41:06 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22OHdQJm029253;
        Thu, 24 Mar 2022 17:41:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3ew6t8sr9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 17:41:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22OHf0iY10813744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 17:41:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC5C9AE045;
        Thu, 24 Mar 2022 17:41:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73904AE04D;
        Thu, 24 Mar 2022 17:41:00 +0000 (GMT)
Received: from osiris (unknown [9.145.160.180])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 24 Mar 2022 17:41:00 +0000 (GMT)
Date:   Thu, 24 Mar 2022 18:40:59 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: gs: move to new header file
Message-ID: <YjytK7iW7ucw/Gwj@osiris>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
 <20220323170325.220848-4-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323170325.220848-4-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: B5zd9KHDrlc8CLpy3tAXgV-whoXC0NBZ
X-Proofpoint-ORIG-GUID: GXWUFWsxk3lmYa1BvweaGJ3khnnimVgl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_06,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=899 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203240097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 06:03:19PM +0100, Nico Boehr wrote:
...
> +static inline unsigned long load_guarded(unsigned long *p)
> +{
> +	unsigned long v;
> +
> +	asm(".insn rxy,0xe3000000004c, %0,%1"
> +	    : "=d" (v)
> +	    : "m" (*p)
> +	    : "r14", "memory");
> +	return v;
> +}

It was like that before, but why is r14 within the clobber list?
That doesn't make sense.
