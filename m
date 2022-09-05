Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F26B5ACC1E
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 09:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbiIEHRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 03:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237246AbiIEHRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 03:17:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A812D40BCE;
        Mon,  5 Sep 2022 00:11:51 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28573O7G028063;
        Mon, 5 Sep 2022 07:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : from : cc : message-id : date; s=pp1;
 bh=7GrxWwcmB+9BcCcwRvyd+J8IQGK+VR5xebQ4hra29Y8=;
 b=WMAOzuPBYK9aUoqE7idTcSH3TXhW5Sv47JWodSCN7vU8kjd232DYAI/acCu4X/Qsod3E
 JRXViNFB5xtd3gIseUmJDkBltdTJwJS79aDGPz8rOASyT6TZJQ8hhnaA/EgqZLjZZL6v
 f4mBzbIE460KIfIS+c7sNDKeSb00YbxaWfEF05z5VHr30WRGUeJV0cO5DOq+KCfadwqh
 yGg7IgBOlX7dnK67LvG5Dt6gtirojHxwpjpmO+LM1Bh0qWRaPZ2APuCdPQMhugg3WF0Y
 P642an/QRx/vLuf/XIyCTPMgrueFr7TXpkuwhKpjJq8NedtDAQXobgIyohO1p3dcOIzr kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdccxg5aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 07:10:38 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28579Qdv023255;
        Mon, 5 Sep 2022 07:10:37 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdccxg59s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 07:10:37 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28578PTd008656;
        Mon, 5 Sep 2022 07:10:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3jbxj8hgqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 07:10:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2857Atse39584250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Sep 2022 07:10:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96667A405B;
        Mon,  5 Sep 2022 07:10:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BD7BA4054;
        Mon,  5 Sep 2022 07:10:32 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.50.84])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Sep 2022 07:10:32 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <03cdbf24b5c5d7024b1108d65c2c478073dab515.camel@linux.ibm.com>
References: <20220826161112.3786131-1-scgl@linux.ibm.com> <20220826161112.3786131-3-scgl@linux.ibm.com> <166204436392.25136.10832970166586747913@t14-nrb> <03cdbf24b5c5d7024b1108d65c2c478073dab515.camel@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v6 2/2] s390x: Test specification exceptions during transaction
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <166236183226.41119.12885497563339983844@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 05 Sep 2022 09:10:32 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S1BiF1Mrh6EQHb4molN04mFfMs8DGzjl
X-Proofpoint-GUID: HziHoNhTxVTbD-nUwKhru6wFxykQaw-e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_04,2022-09-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=849
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209050034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janis Schoetterl-Glausch (2022-09-01 18:08:17)
[...]
> > Hmhm, I am unsure whether a skip is the right thing here. On one hand, =
it might hide bugs, on the other hand, it might cause spurious failures. Wh=
y did you decide for the skip?
>=20
> Yeah, it's a toss-up. Claudio asked me to change it in v4.

Allright, then:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
