Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763576FDA10
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbjEJIyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbjEJIx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:53:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BE36E87;
        Wed, 10 May 2023 01:53:37 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A8kY4l032318;
        Wed, 10 May 2023 08:53:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=fjnoUBc6ub9IcHFbVwkILQF6pXC34u+n2kyx0JSb3Sc=;
 b=nA78l77ewSQL7SPYOqXOH44rF/6SW003weRIIseBSCCxNvgjs8oWkYu1j/HKMHWjbs6w
 7bUFy147H9ksejH2u0zPC/ukE2dwwdtG+KyqHVyznUiYwG9nHebzij3gbpYkRI3N7wkG
 5Lp2VNubli07yysNOtphmBOA99rmQk1bWsqZKCDMUYwwwrfhsSmKEhmxPWKMipE7pKLx
 Bi1lNHkGX6UbY9cI7PXUD7k4E6jQwrA9l7nb3VzVfhLSnCVGlu8pT4Q4edbwP6IUDNDS
 gMurI1BIF6eJlQHOqkVK+eXXGDTitlDtNwwDkYjfWwLuFwBgGT70xrhwT7XnomxIJ2pd tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg6s8tdbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 08:53:34 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34A8lggm004626;
        Wed, 10 May 2023 08:53:33 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg6s8tdb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 08:53:33 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A2k83Y008994;
        Wed, 10 May 2023 08:53:31 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qf7d1rrry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 08:53:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34A8rR2w18678470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 08:53:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C566320049;
        Wed, 10 May 2023 08:53:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2BF420040;
        Wed, 10 May 2023 08:53:27 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.13.202])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 08:53:27 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230502130732.147210-7-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com> <20230502130732.147210-7-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/9] s390x: uv-host: Switch to smp_sigp
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168370880738.331309.12574702517268774387@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 10 May 2023 10:53:27 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: c1blziQiSeUWc-ePNKmrErIGReaxaUtx
X-Proofpoint-ORIG-GUID: 3l_w4j7PSGW6PJwuEgn52jWOu0tXDG8A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=930
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-02 15:07:29)
> Let's move to the new smp_sigp() interface which abstracts cpu
> numbers.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Did you intentionally drop my R-b?

anyways:
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
