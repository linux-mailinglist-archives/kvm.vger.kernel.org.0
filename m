Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D710B70BB99
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 13:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbjEVLVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 07:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbjEVLUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 07:20:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F761FCC;
        Mon, 22 May 2023 04:15:33 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MBD103025377;
        Mon, 22 May 2023 11:15:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : cc : to : subject : message-id : date; s=pp1;
 bh=kMu/7HDiibeWzBdeM+aTotKz1COqRbYEQc0nx3P3CxQ=;
 b=fetfTBBYiTK1pDgmJCfP6Dfb6ixeDlUBP3U7lmi6U+9DiJTbT25e9sugTU75L4fygMAE
 xS68+tphRjG7tMEieolPKStH1pUplJgVFe6lzH619048VDt1FYqSUDbhiKwcSZWtSNX7
 51V9wrLe9JK97KF0EKjA/FFXNEkU+nGQKOPhOPOrDeAC84x+LG1G9HlJe8ZNqa9tTEdW
 R7OOFamCh9+Qv2b5bVTsAKpYl31nZl/dWnw+YEY3KDLEPD29vbPfSbQQVsmQrRVv7eQG
 eEZlYjBjRmSOO3KjG5OzjXx+ZT5JZLLbsGR5+76Oi6hig7iMQ6ULLmooCaAemyoYAhGr xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qqawepe2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 11:15:27 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MB744A001588;
        Mon, 22 May 2023 11:15:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qqawepe2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 11:15:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34M3fjvK027623;
        Mon, 22 May 2023 11:15:25 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qppcu8wtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 11:15:25 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34MBFMbe35324176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 11:15:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DDAE20040;
        Mon, 22 May 2023 11:15:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8CBE2004B;
        Mon, 22 May 2023 11:15:18 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.8.191])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 22 May 2023 11:15:18 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230519112236.14332-2-pmorel@linux.ibm.com>
References: <20230519112236.14332-1-pmorel@linux.ibm.com> <20230519112236.14332-2-pmorel@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v9 1/2] s390x: topology: Check the Perform Topology Function
Message-ID: <168475411852.27238.14110102220289082947@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 22 May 2023 13:15:18 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7JuCXINHHL83iHL5Z5xQ0IOwYlFmNXpe
X-Proofpoint-GUID: Ll0-Vc3tR6kCX-YG-RUsk-XsM2ItW41O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-22_06,2023-05-22_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-05-19 13:22:35)
[...]
> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 0000000..2acede0
> --- /dev/null
> +++ b/s390x/topology.c
[...]
> +static void check_privilege(int fc)
> +{
> +       unsigned long rc;
> +
> +       report_prefix_push("Privilege");
> +       report_info("function code %d", fc);

report() messages should be unique.

Can you please make this a
  report_prefix_pushf("Privileged fc %d", fc);
and get rid of the report_info()?

With this change:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
