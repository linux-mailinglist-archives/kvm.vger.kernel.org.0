Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716D44AF0A5
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 13:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiBIMDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 07:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiBIMDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 07:03:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79E7C0302F1;
        Wed,  9 Feb 2022 03:37:57 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2199fxLh008943;
        Wed, 9 Feb 2022 11:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=lMtqS1y77MDWxMqm5wSHFN+IduCnzkp9L8uft2wB14o=;
 b=Dj7rNkvzHpgKL+E91BM8bo0Nkd486BcmZCozQ45eJf2t8O8OTDSlEunIJCYnIfXCE/Q6
 JOeATadCDRfnBSZj2+U9z1XGiTgKD0+0SLeWSSkGHAWji3QnozMoK5LqGYfe/5dEzOcw
 T8dJF95IbvT+rM2/DPuFXptFzUhzPIlLNN9+fnflPureA2R31en6UjnAgixrVxMqmr1Q
 Y8snmdZd3Lwhybd+70eSu+QNiNjtBBh4PQnq203nionLordCPk0MYiRcyymvZuWpdvix
 CyAxzPLGSxMqITRpv3iQajdG0N0gW9hX7R9ef2apLlg4J2883jLtg+4E4OTppjuSPHpO /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e48c16a2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 11:37:57 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219AH30K032693;
        Wed, 9 Feb 2022 11:37:56 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e48c16a2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 11:37:56 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219BWfpK008693;
        Wed, 9 Feb 2022 11:37:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3e1gvacvt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 11:37:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219BboAb38535578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 11:37:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D85D911C050;
        Wed,  9 Feb 2022 11:37:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8534E11C052;
        Wed,  9 Feb 2022 11:37:50 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.14.49])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 11:37:50 +0000 (GMT)
Message-ID: <8dd704d23f8a14907ed2a7f28ec3ac52685ab96c.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 3/4] s390x: topology: Check the
 Perform Topology Function
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Date:   Wed, 09 Feb 2022 12:37:50 +0100
In-Reply-To: <20220208132709.48291-4-pmorel@linux.ibm.com>
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
         <20220208132709.48291-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NieLZsO-TM8IBOkpof1MGK83JaIbUh5r
X-Proofpoint-ORIG-GUID: XDOEdq5U99fUgLzxz4Q8aF0LYSqyH81c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_06,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=910
 malwarescore=0 spamscore=0 bulkscore=0 clxscore=1015 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202090071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-08 at 14:27 +0100, Pierre Morel wrote:
> We check the PTF instruction.

You could test some very basic things as well:

- you get a privileged pgm int in problem state,
- reserved bits in first operand cause specification pgm int,
- reserved FC values result in a specification pgm int,
- second operand is ignored.

> 
> - We do not expect to support vertical polarization.
> 
> - We do not expect the Modified Topology Change Report to be
[...]

Forgive me if I'm missing something, but why _Modified_ Topology Change
Report?

> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 00000000..a1f9ce51
> --- /dev/null
> +++ b/s390x/topology.c

[...]

> +static int ptf(unsigned long fc, unsigned long *rc)
> +{
> +       int cc;
> +
> +       asm volatile(
> +               "       .insn   rre,0xb9a20000,%1,0\n"
> +               "       ipm     %0\n"
> +               "       srl     %0,28\n"
> +               : "=d" (cc), "+d" (fc)
> +               : "d" (fc)

Why list fc here again?


