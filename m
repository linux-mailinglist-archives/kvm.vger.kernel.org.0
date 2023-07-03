Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA07745BC2
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 13:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjGCL6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 07:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjGCL6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 07:58:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4AB92;
        Mon,  3 Jul 2023 04:58:06 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 363BrFk8009285;
        Mon, 3 Jul 2023 11:58:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=npN4syoqnqfla5f4qMiXdUnBPSWU8bPjSYdNxRir4Gk=;
 b=ryhYB2pBVOFY5EuCT4qGtPe8tOCCq/lr+fXPNcGx/0SLl7xAb7VMmAAUJ8OqFpteO94S
 yvRMe0TLaoUzdUyIRsVtsIndtt4sKWrfUatv1+kKQW373v+4A0jpnSsyeox5BIvyhJ/Z
 /FW5Nm5el5c4VfMJOnpX2750e+5b9cwa3lE8rS2eTqnXUqE6UDhtcNyuiOv1/ck9J8Sh
 6jNp9cuttMhG0WoNC/MCGDr3JnQ4IUS6Xk8U4cPDBmQFKi9syrOXTYLvAanOlO+O/pXO
 K3KR2lL9t2mKC50gPTZko53isCyg2BLj4tb/uXvzwI34bs1Jrtwf72zo079vdS+rOjtI Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkwupg252-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 11:58:05 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 363BsuY6012724;
        Mon, 3 Jul 2023 11:58:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkwupg24a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 11:58:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3633Bt07008376;
        Mon, 3 Jul 2023 11:58:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rjbs4s9wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 11:58:03 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 363Bw0hu61932004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jul 2023 11:58:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBDFA20043;
        Mon,  3 Jul 2023 11:57:59 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1B4220040;
        Mon,  3 Jul 2023 11:57:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jul 2023 11:57:59 +0000 (GMT)
Date:   Mon, 3 Jul 2023 13:57:58 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests RFC 2/3] lib: s390x: sclp: Clear ASCII screen
 on setup
Message-ID: <20230703135758.19a7c5fd@p-imbrenda>
In-Reply-To: <74940751-4aab-3bb5-d294-3e73e3049a95@linux.ibm.com>
References: <20230630145449.2312-1-frankja@linux.ibm.com>
        <20230630145449.2312-3-frankja@linux.ibm.com>
        <20230630172558.3edfa9ec@p-imbrenda>
        <74940751-4aab-3bb5-d294-3e73e3049a95@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KlYzeVdydIeH3v2tqKAaCiNgq4IF4jyH
X-Proofpoint-GUID: hMpPH_NciuBHvgu9G8h3WdtmPMwR8S6N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-03_09,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307030104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jul 2023 13:36:05 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/30/23 17:25, Claudio Imbrenda wrote:
> > On Fri, 30 Jun 2023 14:54:48 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> In contrast to the line-mode console the ASCII console will retain  
> > 
> > what's the problem with that?  
> 
> It can be a bit hard to read since you need to find the line where the 
> old output ends and the new one starts.
> 
> 
> I don't insist on this patch being included, the \r and sclp line mode 
> input patches give me enough usability.

make it a compile-time option? (default off)

then you won't need to change the run script, and you can still clear
the console when you need it (HMC)
