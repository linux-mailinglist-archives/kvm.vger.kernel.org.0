Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B1E71FBD0
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 10:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbjFBIY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 04:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbjFBIYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 04:24:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1486D1A7;
        Fri,  2 Jun 2023 01:24:46 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3528Hn7a017742;
        Fri, 2 Jun 2023 08:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : cc : subject : to : message-id : date; s=pp1;
 bh=AJ5jfwjCkfHvixKCptzj1ugCsJ6w0iYOf7eS44f+tD8=;
 b=OWu4uBJGN/tAwsBRFYjoZQ2eWVYRwdsQnPJHsbdRbWXKVZfWPT1CpQOaf1BGdRogTF6c
 ZF4YIftEQyA1iDJ5/F03nvBFhEuG1CnNoQKJXOctW5zEw1o0uVSRiVXNHrPf+n6KV987
 CYrquYIWZQ5yEz0NAGluY1q7beddxrZKff6vqsslw6N2Kx+zEQtNchc69nDekFxuFnVw
 BKBktb/ETEtOf828J57jS6Yp7f08r6cxXbeuHbMGdySVYILMNIHgDPv0flZHvX8PtAFc
 16zNprPWh4BPaIbV7I+4nc99kOWvt7cbaJJT89wAXs84a5lg3nfSP8T3t61pkdscwfUx lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qycshr47c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:24:45 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3528JPJE023090;
        Fri, 2 Jun 2023 08:24:45 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qycshr46n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:24:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3526JZIG018965;
        Fri, 2 Jun 2023 08:24:42 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qu9g52ep4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:24:42 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3528OdkI21627136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jun 2023 08:24:39 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 168F820067;
        Fri,  2 Jun 2023 08:24:39 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7E6820065;
        Fri,  2 Jun 2023 08:24:38 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.63.101])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  2 Jun 2023 08:24:38 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230601164537.31769-1-pmorel@linux.ibm.com>
References: <20230601164537.31769-1-pmorel@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com,
        cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5 0/2] Fixing infinite loop on SCLP READ SCP INFO error
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Message-ID: <168569427857.252746.9448026786076856625@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 02 Jun 2023 10:24:38 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MsmSTmP7WGQWgWu6RzW4GbMVqjx7aIOf
X-Proofpoint-ORIG-GUID: lkb_x1lYmnguzeB4y3RSuZtUx8O5D111
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_05,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=633 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-06-01 18:45:35)
> Aborting on SCLP READ SCP INFO error leads to a deadloop.
>=20
> The loop is:
> abort() -> exit() -> smp_teardown() -> smp_query_num_cpus() ->
> sclp_get_cpu_num() -> assert() -> abort()
>=20
> Since smp_setup() is done after sclp_read_info() inside setup() this
> loop only happens when only the start processor is running.
> Let sclp_get_cpu_num() return 1 in this case.
>=20
> Also provide a bigger buffer for SCLP READ INFO when we have the
> extended-length-SCCB facility.
>=20
> Pierre

Thanks for your patience Pierre.

Pushed to devel with the fixup to patch 2.
