Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D7231EE59
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhBRScz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:32:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3132 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232130AbhBRRfC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 12:35:02 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IHXxuV040499
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:34:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=fDmQsUKDrixNuqYATDnYtFrn46IuoVoX+WWxwtWfPJw=;
 b=bxtZ7akh5tGIjn2g1d/VVeJRbtIWJ02CBcsUUG21Nue3J6dSM76sB5hdA0UwSTE3Rt2j
 ausgV6e6Aon08KpPhvjAVcQ8OwuWbdFpKnC+nbknYfPQqsozJkUJh7rkbbLtoanXQBTT
 WVCPyGwnPTaowRtJB6rCtYnXqJeJrqr4unsjwflpwwMrjJVdhGGHq49lbj1zPOkMik47
 Moa+H9kOU/TufWS7b3HZNjozd7Su400GeUABOnoMk9c6GsAIVR0dGTE+HlE9FnFsrOmx
 6dIQiXT8UWLkmrII9TmjjJjciYxeH19tMyO+SCvffbP9ssvUZzupzD1lWHh1XiDyvOd9 bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36sttvcsw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:34:13 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IHYCVa041784
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:34:12 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36sttvcsmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 12:34:09 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IHNqPQ013892;
        Thu, 18 Feb 2021 17:33:47 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 36rw3u9g41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 17:33:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IHXiO846006758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:33:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFE88A4060;
        Thu, 18 Feb 2021 17:33:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F583A4054;
        Thu, 18 Feb 2021 17:33:44 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.94.58])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 17:33:44 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, pasic@linux.ibm.com
Subject: [PATCH 0/1] css: SCHIB measurement block origin must be aligned
Date:   Thu, 18 Feb 2021 18:33:42 +0100
Message-Id: <1613669623-7328-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_09:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

By testing Measurement with KVM unit tests I fall on this:
we forgot to test the alignment of the MBO for measurement format 1.

The MB must be aligned on 128bits otherwise an operand exception
is recognized.

Regards,
Pierre

Pierre Morel (1):
  css: SCHIB measurement block origin must be aligned

 target/s390x/ioinst.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
2.25.1

