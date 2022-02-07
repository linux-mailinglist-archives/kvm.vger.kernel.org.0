Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFAF4AC98F
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 20:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbiBGT1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 14:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240637AbiBGTYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 14:24:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00831C0401E6;
        Mon,  7 Feb 2022 11:24:45 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217IQ5Vb005295;
        Mon, 7 Feb 2022 19:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=W+3RF4+TSI5ssviTeFqGmaNMt1m1811Eopoel3gqsX4=;
 b=SNZKsTEHBqef7xnM2pHFHys/3UBNNaMj7qF2gqQPP5zJt5K4RLd144J5R7B1KMttbsq3
 cAD3haVj6C3QJsuUz+OUvrIqU0OlzhgbX7ZizrOXYAp3wbu1EtQLO+1FhwdGZ5iE5VHS
 /wRkW1EnG4sFRkYAJqQ9fkGdd3WRqloItYmRv3LRCQEYJt2JRPIf9taYlnHOey1yy3Sw
 drbrW8sVs1qdgaSuNTzta4mh1N+OqZPkmGefpTcC3iG3hTkdf58S/ZlZIIoMEROMXd2h
 lL/6PSltQn1+3sL3SC3Sv1VCgKLnW3ePuox8g3w/NMCDxiUDws+NrjJ/GNuyR/H5VDoj TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355aexnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 19:24:45 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217IaYkk005641;
        Mon, 7 Feb 2022 19:24:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355aexmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 19:24:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217J8Udo022771;
        Mon, 7 Feb 2022 19:24:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gv8yr3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 19:24:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217JOd5J34537880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 19:24:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E150AE057;
        Mon,  7 Feb 2022 19:24:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DB58AE045;
        Mon,  7 Feb 2022 19:24:38 +0000 (GMT)
Received: from osiris (unknown [9.145.47.238])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  7 Feb 2022 19:24:38 +0000 (GMT)
Date:   Mon, 7 Feb 2022 20:24:37 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2 01/11] s390/uaccess: Add copy_from/to_user_key
 functions
Message-ID: <YgFx9XIWvrPAeSNk@osiris>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
 <20220207165930.1608621-2-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207165930.1608621-2-scgl@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C83dn5awiSbA2ceuYPoP1K7OqbqzPL--
X-Proofpoint-ORIG-GUID: VbxGmKnRkMsQ5OOssbczvlDYbwZrHcsQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxlogscore=805 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 07, 2022 at 05:59:20PM +0100, Janis Schoetterl-Glausch wrote:
> Add copy_from/to_user_key functions, which perform storage key checking.
> These functions can be used by KVM for emulating instructions that need
> to be key checked.
> These functions differ from their non _key counterparts in
> include/linux/uaccess.h only in the additional key argument and must be
> kept in sync with those.
> 
> Since the existing uaccess implementation on s390 makes use of move
> instructions that support having an additional access key supplied,
> we can implement raw_copy_from/to_user_key by enhancing the
> existing implementation.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  arch/s390/include/asm/uaccess.h | 22 +++++++++
>  arch/s390/lib/uaccess.c         | 81 +++++++++++++++++++++++++--------
>  2 files changed, 85 insertions(+), 18 deletions(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>

Christian, Janosch, I think this can go via the kvm tree.
