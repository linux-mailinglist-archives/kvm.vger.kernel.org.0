Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3E74229F
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 10:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjF2IvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 04:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbjF2Iuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 04:50:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23246421A;
        Thu, 29 Jun 2023 01:49:08 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35T8lP9E026485;
        Thu, 29 Jun 2023 08:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : cc : from : message-id : date; s=pp1;
 bh=CPEZKTFGArkfH+Z2Raqhoh8WFWmAADuhRAWfREv/SOQ=;
 b=Vw+Y0zikiMZ11VjSC4bqYbOPJ4fdxH5ZnVkDV4a0BDI89yqsvc53LEorzJf7BjooWPkt
 wdqQGh8PR/JA1nR6KRJpi9rlvcy0fb1qPj41+MxmO2EqGvrxEoNtAywykAAr9CkSmdi5
 E/VrFrz5f4M5dDpAihbD5ZVkGGNsdav6c1RcSdEK7hPVVRTT2W+Fq+5WJDaxdDgo++Cr
 u1rvbFd/C0VY/XyyUG7OeoKx4d+pcmCia6+ArJ1OQAE1/ZbiZe9j/if4p8pprxqHYnJH
 PKK8Zdnzhu+XXGsD2lYTjeuF06BmPX0NjgiJmg4WJZSMZQrSXssxtGGL6zb0gwf2WxBM lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rh6rc01c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:49:07 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35T8lakl026913;
        Thu, 29 Jun 2023 08:49:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rh6rc01bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:49:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35T4hQA2012699;
        Thu, 29 Jun 2023 08:49:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rdr4538b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:49:04 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35T8n1ZC6226484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 08:49:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57CA620040;
        Thu, 29 Jun 2023 08:49:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E60C20043;
        Thu, 29 Jun 2023 08:49:01 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.34])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jun 2023 08:49:01 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230627082155.6375-2-pmorel@linux.ibm.com>
References: <20230627082155.6375-1-pmorel@linux.ibm.com> <20230627082155.6375-2-pmorel@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v10 1/2] s390x: topology: Check the Perform Topology Function
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168802854091.40048.12063023827984391132@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 29 Jun 2023 10:49:00 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k2zliwP5EvpwG9rFgK9ldvB6U54R0pcK
X-Proofpoint-GUID: 4yisU39ozzFURiZZfr9XrduThoX0MEDt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-28_14,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=999
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

Quoting Pierre Morel (2023-06-27 10:21:54)
[...]
> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 0000000..7e1bbf9
> --- /dev/null
> +++ b/s390x/topology.c
> @@ -0,0 +1,190 @@
[...]
> +static void check_privilege(int fc)
> +{
> +       unsigned long rc;
> +       char buf[20];
> +
> +       snprintf(buf, sizeof(buf), "Privileged fc %d", fc);
> +       report_prefix_push(buf);

We have report_prefix_pushf (note the f at the end!) for this.

I can fix that up when picking in case there's no new version, though.
