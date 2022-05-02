Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D8851762E
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244294AbiEBSBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 14:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiEBSBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 14:01:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00467DE6;
        Mon,  2 May 2022 10:58:22 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242HpdvH026019;
        Mon, 2 May 2022 17:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=OnbL/YbZ/pFdIQ20YAOwNHPJyh6n17KQmF/QAh/zwMM=;
 b=HpVldZEkMLglethcdqBTXTtBNXSW+/g05//upemzRjV9gaH4k86r5Lf1JeBrGSw757y/
 AYSiupMK8lvfgM6bB1NoRF4p8Jhx9s20m1meYgQLju6cTldNKLBS4eBGWZ+kiH7duXwj
 ozzhUqlGX0qkTAiDfd33cxNXjyPGCTsUzeWoHMYHW1aQXgYBJJ+IVjeXbyQajBU1Ojhz
 ld87ynEVgZj0bWXd6ZfUfjsq///06MNmLoZPj+x6jL11no8nVHDDm8x3M6a0UY44eN7y
 N82sKKQwBmZjPTlmVKM986luOUDVJuba+MZoJzuZcn6gkCOa759iAqLcfyP8/dng0dne Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftk5n99a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 17:58:22 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 242HuMj8015022;
        Mon, 2 May 2022 17:58:22 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftk5n999a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 17:58:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242HwJBw004945;
        Mon, 2 May 2022 17:58:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3frvr8tyra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 17:58:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242HwHYr23068980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 17:58:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B8BCA4055;
        Mon,  2 May 2022 17:58:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6704A4051;
        Mon,  2 May 2022 17:58:15 +0000 (GMT)
Received: from osiris (unknown [9.145.50.234])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  2 May 2022 17:58:15 +0000 (GMT)
Date:   Mon, 2 May 2022 19:58:14 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [GIT PULL 0/1] KVM: s390: Fix lockdep issue in vm memop
Message-ID: <YnAbtskXVQP11AkF@osiris>
References: <20220502153053.6460-1-borntraeger@linux.ibm.com>
 <47855c4c-dc85-3ee8-b903-4acf0b94e4a9@redhat.com>
 <249d0100-fa58-bf48-b1d2-f28e94c3a5f2@linux.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <249d0100-fa58-bf48-b1d2-f28e94c3a5f2@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cRxzM0gYZpG6KR6W4Rlv-Qb4P7WqI8XG
X-Proofpoint-ORIG-GUID: UJv4wA1iGZ6hPYx2LQ3Skd2sXJ_-Ij3x
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_05,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=989
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022 at 05:41:13PM +0200, Christian Borntraeger wrote:
> Am 02.05.22 um 17:39 schrieb Paolo Bonzini:
> > On 5/2/22 17:30, Christian Borntraeger wrote:
> > > Paolo,
> > > 
> > > one patch that is sitting already too long in my tree (sorry, was out of
> > > office some days).
> > 
> > Hi Christian,
> > 
> > at this point I don't have much waiting for 5.18.  Feel free to send it through the s390 tree.
> 
> OK.
> 
> Heiko, Vasily, can you queue this for your next pull request?
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> for carrying this via the s390 tree.

It's now on the fixes branch:
https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git/log/?h=fixes

Actually I was waiting if some fixes would come in, since the fixes
branch also had only one small fix until now.
