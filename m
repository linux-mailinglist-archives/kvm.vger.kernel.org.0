Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7648374229C
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 10:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjF2IvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 04:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233032AbjF2Iud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 04:50:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87B9420C;
        Thu, 29 Jun 2023 01:47:58 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35T8lOp0026417;
        Thu, 29 Jun 2023 08:47:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : cc : from : message-id : date; s=pp1;
 bh=xXw3rbHo/e9Nn+S2MseHRvoqZtEfSE+HkxorPUJhQzw=;
 b=nY0e0umbhUokjkWB7jHszp9dv+K/P1ngeHycIREmTmWx/pbPrWoh6q5ozuCLFf/MRiTF
 qEVkyU48Sb06kFq92fTy4MGpN5SxqCH9tDGji/f9KA6dMvN04I60xCRvSkCAYa6l27U5
 SwuHbOzpE6yTCXcw8JyRCXWnY0uw5Xo8a9pZLecehhwIU/tofanhjfHBCdBmpekyPsI/
 rtQDWbnDbCJKUCvwy9Ss7CGxRNVQA5TrNPT+6hJAr/AEB6Ri2l6OGgZB//1yywil9OMr
 T4RyAYlpIWDSX6FLzCU2G0ThuvwLGoGDF76CvRa4fjITH7O9sipLo7R0P96QeQsuQduB 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rh6rc00kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:47:58 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35T8lvrI029463;
        Thu, 29 Jun 2023 08:47:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rh6rc00jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:47:57 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35T7gASB001827;
        Thu, 29 Jun 2023 08:47:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rdr452dhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:47:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35T8lq03459462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 08:47:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0420620043;
        Thu, 29 Jun 2023 08:47:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFE1C20040;
        Thu, 29 Jun 2023 08:47:51 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.34])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jun 2023 08:47:51 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230627082155.6375-3-pmorel@linux.ibm.com>
References: <20230627082155.6375-1-pmorel@linux.ibm.com> <20230627082155.6375-3-pmorel@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v10 2/2] s390x: topology: Checking Configuration Topology Information
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168802847164.40048.638611072486381061@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 29 Jun 2023 10:47:51 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YO0wn86rGtFwy_wcHRk7fem6GfBXS5Fq
X-Proofpoint-GUID: ixqhPuKXx0-QMCcOjvyL60gwyB7wasW-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-28_14,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306290075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-06-27 10:21:55)
> STSI with function code 15 is used to store the CPU configuration
> topology.
>=20
> We retrieve the maximum nested level with SCLP and use the
> topology tree provided by sockets and cores only to stay
> compatible with qemu topology before topology extension with
> drawers and books.
> arguments.
>=20
> We check :
> - if the topology stored is coherent between the QEMU -smp
>   parameters and kernel parameters.
> - the number of CPUs
> - the maximum number of CPUs
> - the number of containers of each levels for every STSI(15.1.x)
>   instruction allowed by the machine.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
