Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85A04E7510
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 15:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345538AbiCYOcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 10:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244990AbiCYOcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 10:32:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04977C3378;
        Fri, 25 Mar 2022 07:30:57 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PCZdwG022452;
        Fri, 25 Mar 2022 14:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=kMk1LxLVHKkL/2ftP65lesnppNcjQz8jh4LQkt62DFM=;
 b=pQBzEURdWyw8K4AWtjq6NJQ8/GxAFTzE6BAyzvBVTJtgoz8QJtnQlToil6eRHFs4A+4f
 1jvppMgSyhpStBTHlrt38uqmKb/X+xW/tnWjr3lgaZ9E9me2U+XO09Gywj9mrD44ROBF
 mQ6Pt0HEctS7HqbqMNSxN5rDJAdw6QV9uL5klJNORIOtuncV7kO5TxVAFbXQcajlJd2O
 3jEq3wU/5mTYHxne1TcfDBPU7iIUN+rojk+ySt1FTbtiX6cl+VbmsTapYj52cqqSGVYc
 ZZ7+KIJjcKkuvi/xYuyYP/s+66FctPCihLzvtxIKO292dk/G6oiWYhqcjylkt3k6Bvoz yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0rqbnmhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 14:30:57 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22PD5OIT011370;
        Fri, 25 Mar 2022 14:30:56 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0rqbnmgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 14:30:56 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PEFCfi017796;
        Fri, 25 Mar 2022 14:30:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3ew6ej3h10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 14:30:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PEJ3Yi48759270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 14:19:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAC70A4060;
        Fri, 25 Mar 2022 14:30:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E59DA4054;
        Fri, 25 Mar 2022 14:30:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.92])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Mar 2022 14:30:51 +0000 (GMT)
Date:   Fri, 25 Mar 2022 15:30:48 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: gs: move to new header
 file
Message-ID: <20220325153048.48306e40@p-imbrenda>
In-Reply-To: <a2870c6b-6b2a-0a81-435e-ec0f472697c6@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
        <20220323170325.220848-4-nrb@linux.ibm.com>
        <YjytK7iW7ucw/Gwj@osiris>
        <a2870c6b-6b2a-0a81-435e-ec0f472697c6@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dAzK7MXbh9EsaGE02TGPd-dzWx7-nSJa
X-Proofpoint-ORIG-GUID: SHGRul0swNAcneqVwSNJgZS8Ufg8OHGe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_04,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=903
 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203250079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Mar 2022 08:29:11 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 3/24/22 18:40, Heiko Carstens wrote:
> > On Wed, Mar 23, 2022 at 06:03:19PM +0100, Nico Boehr wrote:
> > ...  
> >> +static inline unsigned long load_guarded(unsigned long *p)
> >> +{
> >> +	unsigned long v;
> >> +
> >> +	asm(".insn rxy,0xe3000000004c, %0,%1"
> >> +	    : "=d" (v)
> >> +	    : "m" (*p)
> >> +	    : "r14", "memory");
> >> +	return v;
> >> +}  
> > 
> > It was like that before, but why is r14 within the clobber list?
> > That doesn't make sense.  
> 
> r14 is changed in the gs handler of the gs test which is executed if the 
> "guarded" part of the load takes place.

I will add a comment explaining that when picking the patch
